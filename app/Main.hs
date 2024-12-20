module Main where
import System.IO
import System.Win32.Console (setConsoleOutputCP)
import System.Random
import Data.Char (isNumber)
import Text.Read (readMaybe)
import Data.Maybe (fromMaybe)
import Control.Exception (catch, IOException)
import System.Exit (exitFailure)

main :: IO ()
main = do
  -- Set up Windows console for emoji output
  setConsoleOutputCP 65001
  hSetEncoding stdout utf8
  
  -- Load dictionary once at startup
  dictionary <- loadDictionary `catch` handleIOError
  
  let attemptsCount = 6
  
  putStrLn "Select mode ('game', 'helper'): "
  input <- getLine
  case input of
    "game" -> handleGameMode attemptsCount dictionary
    "helper" -> handleHelperMode dictionary
    _ -> putStrLn "Invalid mode. Please select 'game' or 'helper'"

handleGameMode :: Int -> [String] -> IO ()
handleGameMode attemptsCount dictionary = do
  putStrLn "Select difficulty ('easy', 'standart', 'hard'): "
  difficulty <- getLine
  case difficulty of
    "easy" -> handleEasyMode attemptsCount dictionary
    "standart" -> handleStandartMode attemptsCount dictionary
    "hard" -> handleHardMode attemptsCount dictionary
    _ -> putStrLn "Invalid difficulty. Please select 'easy', 'standart', or 'hard'"

handleEasyMode :: Int -> [String] -> IO ()
handleEasyMode attemptsCount dictionary = do
  maybeLengthOfWord <- getValidWordLength
  case maybeLengthOfWord of
    Nothing -> putStrLn "Invalid word length"
    Just lengthOfWord -> do
      let filteredDict = filter (\x -> length x == lengthOfWord) dictionary
      if null filteredDict
        then putStrLn "No words found with that length"
        else do
          putStrLn "Generating word... "
          word <- generateRandomWord filteredDict
          easyMode word attemptsCount lengthOfWord [] []

handleStandartMode :: Int -> [String] -> IO ()
handleStandartMode attemptsCount dictionary = do
  maybeLengthOfWord <- getValidWordLength
  case maybeLengthOfWord of
    Nothing -> putStrLn "Invalid word length"
    Just lengthOfWord -> do
      let filteredDict = filter (\x -> length x == lengthOfWord) dictionary
      if null filteredDict
        then putStrLn "No words found with that length"
        else do
          putStrLn "Generating word... "
          word <- generateRandomWord filteredDict
          standartMode word attemptsCount lengthOfWord

handleHardMode :: Int -> [String] -> IO ()
handleHardMode attemptsCount dictionary = do
  maybeLengthOfWord <- getValidWordLength
  case maybeLengthOfWord of
    Nothing -> putStrLn "Invalid word length"
    Just lengthOfWord -> do
      let filteredDict = filter (\x -> length x == lengthOfWord) dictionary
      if null filteredDict
        then putStrLn "No words found with that length"
        else do
          putStrLn "Generating word... "
          word <- generateRandomWord filteredDict
          attemptsLieIndex <- getStdRandom (randomR (0, attemptsCount))
          positionOfLieInWord <- getStdRandom (randomR (0, lengthOfWord))
          hardMode word attemptsCount lengthOfWord attemptsLieIndex positionOfLieInWord

handleHelperMode :: [String] -> IO ()
handleHelperMode dictionary = do
  maybeLengthOfWord <- getValidWordLength
  case maybeLengthOfWord of
    Nothing -> putStrLn "Invalid word length"
    Just lengthOfWord -> do
      let filteredDict = filter (\x -> length x == lengthOfWord) dictionary
      if null filteredDict
        then putStrLn "No words found with that length"
        else helperMode filteredDict "" "" (unknownWord lengthOfWord) lengthOfWord

-- Helper functions

loadDictionary :: IO [String]
loadDictionary = do
  contents <- readFile "dictionary.txt"
  let dict = lines contents
  if null dict
    then error "Dictionary is empty"
    else return dict

handleIOError :: IOException -> IO [String]
handleIOError e = do
  putStrLn $ "Error loading dictionary: " ++ show e
  exitFailure

getValidWordLength :: IO (Maybe Int)
getValidWordLength = do
  putStrLn "Enter word length: "
  input <- getLine
  return $ readMaybe input

generateRandomWord :: [String] -> IO String
generateRandomWord dictionary = do
  i <- getStdRandom (randomR (0, length dictionary - 1))
  return $ dictionary !! i

data Color
  = Green
  | Yellow
  | Gray
  deriving (Enum, Eq, Show)

toEmoji :: Color -> Char
toEmoji a = case a of
  Green -> '🟩'
  Yellow -> '🟨'
  Gray -> '⬜'
  -- Green -> 'g'
  -- Yellow -> 'y'
  -- Gray -> 'o'

containsLetter :: String -> Char -> Bool
containsLetter [] _ = False
containsLetter (x:xs) y = y == x || containsLetter xs y

colorConnection :: String -> String -> String -> [Color]
colorConnection [] _ _ = []
colorConnection _ [] _ = []
colorConnection guess@(x:xs) comparable@(y:ys) word
  | x == y = Green : colorConnection xs ys word
  | containsLetter word y = Yellow : colorConnection xs ys word
  | otherwise = Gray : colorConnection xs ys word

gameWon :: [Color] -> Bool
gameWon = foldr (\ x -> (&&) (x == Green)) True

-----------------------------------------------------------------_GAME_MODES_-----------------------------------------------------------------

standartMode :: String -> Int -> Int -> IO ()
standartMode [] _ _ = do
  putStrLn "Invalid word"

standartMode word 0 _ = do
  putStrLn $ "Game over! The word was " ++ word

standartMode word n lengthOfWord = do
  putStrLn $ "Enter guess (Attempts left: " ++ show n ++ "): "
  guess <- getLine

  file <- readFile "dictionary.txt"
  let dictionaryNotFiltered = lines file
  let dictionary = filter (\x -> length x == lengthOfWord) dictionaryNotFiltered

  if length guess /= lengthOfWord
    then do
      putStrLn $ "Enter " ++ show lengthOfWord ++ " characters!"
      standartMode word n lengthOfWord
  else do
    let answer = colorConnection word guess word
    putStrLn $ map toEmoji answer

    if gameWon answer then putStrLn "You win!"
    else standartMode word (n - 1) lengthOfWord

easyMode :: String -> Int -> Int -> [Char] -> [Int] -> IO ()
easyMode [] _ _ _ _ = do
  putStrLn "Invalid word"

easyMode word 0 _ _ _ = do
  putStrLn $ "Game over! The word was " ++ word

easyMode word n lengthOfWord usedLetters fixedLetters = do
  if usedLetters /= []
    then do
      putStrLn "Currently used letters: "
      printLetters usedLetters
      putStrLn ""
      let letters = lettersInTheWord word usedLetters
      if letters /= []
        then do
          putStrLn "Currently guessed letters: "
          printLetters letters
          putStrLn ""
          if fixedLetters /= []
            then do
              putStrLn "Currently fixed letters: "
              printFixedLetters word 1 fixedLetters
          else putStrLn "No fixed letters yet"
      else putStrLn "No guessed letters yet"
  else putStrLn "No used letters yet"

  putStrLn $ "Enter guess (Attempts left: " ++ show n ++ "): "
  guess <- getLine

  file <- readFile "dictionary.txt"
  let dictionaryNotFiltered = lines file
  let dictionary = filter (\x -> length x == lengthOfWord) dictionaryNotFiltered

  if length guess /= lengthOfWord
    then do
      putStrLn $ "Enter " ++ show lengthOfWord ++ " characters!"
      easyMode word n lengthOfWord usedLetters fixedLetters
  else if not (contains guess dictionary)
    then do
      putStrLn "Word not in dictionary"
      easyMode word n lengthOfWord usedLetters fixedLetters
  else if not (lettersInPlace word guess fixedLetters)
    then do
      putStrLn "Not using an already guessed letter. Try again!"
      easyMode word n lengthOfWord usedLetters fixedLetters
  else if lettersCrossedOut guess word usedLetters
    then do
      putStrLn "Using an already crossed out letter. Try again!"
      easyMode word n lengthOfWord usedLetters fixedLetters
  else do
    let answer = colorConnection word guess word
    putStrLn $ map toEmoji answer

    let newFixedLetters = updateFixedLetters fixedLetters 1 answer
    let newUsedLetters = addLetters guess usedLetters

    if gameWon answer then putStrLn "You win!"
    else easyMode word (n - 1) lengthOfWord newUsedLetters newFixedLetters

hardMode :: String -> Int -> Int -> Int -> Int -> IO ()
hardMode [] _ _ _ _ = do
  putStrLn "Invalid word"

hardMode word 0 _ _ _ = do
  putStrLn $ "Game over! The word was " ++ word

hardMode word n lengthOfWord attemptsLieIndex positionOfLieInWord = do
  putStrLn $ "Enter guess (Attempts left: " ++ show n ++ "): "
  guess <- getLine

  file <- readFile "dictionary.txt"
  let dictionaryNotFiltered = lines file
  let dictionary = filter (\x -> length x == lengthOfWord) dictionaryNotFiltered

  if length guess /= lengthOfWord
    then do
      putStrLn $ "Enter " ++ show lengthOfWord ++ " characters!"
      hardMode word n lengthOfWord attemptsLieIndex positionOfLieInWord
  else do
    let answer = colorConnection word guess word
    if attemptsLieIndex == n
      then do
        let lie = lieGenerator answer positionOfLieInWord
        putStrLn $ map toEmoji lie
    else putStrLn $ map toEmoji answer

    if gameWon answer then putStrLn "You win!"
    else hardMode word (n - 1) lengthOfWord attemptsLieIndex positionOfLieInWord

----------------------------------------------------------------------------------------------------------------------------------------------

contains :: Eq a => a -> [a] -> Bool
contains elem myList
  = case myList of
      [] -> False
      x : xs | x == elem -> True
      _ : xs -> contains elem xs

addLetters :: String -> [Char] -> [Char]
addLetters [] y = y
addLetters (x:xs) y =
  if contains x y
    then addLetters xs y
  else addLetters xs (x : y)

printLetters :: String -> IO ()
printLetters [] = return ()
printLetters (x:xs) = do
  putChar x
  putChar ' '
  printLetters xs

printFixedLetters :: String -> Int -> [Int] -> IO ()
printFixedLetters [] _ _ = putStrLn ""
printFixedLetters (x:xs) index fixedLetters = 
  if contains index fixedLetters
    then do
      putChar x
      putChar ' '
      printFixedLetters xs (index + 1) fixedLetters
  else printFixedLetters xs (index + 1) fixedLetters

--Fills a Char array containing already used letters
--Use: easy mode
lettersInTheWord :: String -> [Char] -> [Char]
lettersInTheWord _ [] = []
lettersInTheWord word (x:xs) =
  if contains x word
    then x : lettersInTheWord word xs
  else lettersInTheWord word xs

--Returns a Char in range 1 - lengthOfWord
--No corner case checks because it is only used in safe functions (No input)
letterAtIndex :: String -> Int -> Char
letterAtIndex (x:xs) 1 = x
letterAtIndex (x:xs) n = letterAtIndex xs (n - 1)

--Returns whether the input matches all the Green squares
--Use: easy mode
lettersInPlace :: String -> String -> [Int] -> Bool
lettersInPlace _ _ [] = True
lettersInPlace _ [] _ = True
lettersInPlace [] _ _ = True
lettersInPlace word guess (z:zs) =
  letterAtIndex word z == letterAtIndex guess z &&
  lettersInPlace word guess zs

--Adds indexes of new fixed letters
--Use: easy mode
updateFixedLetters :: [Int] -> Int -> [Color] -> [Int]
updateFixedLetters fixedLetters _ [] = fixedLetters
updateFixedLetters fixedLetters n (x:xs) =
  if x == Green && not (contains n fixedLetters)
    then updateFixedLetters (n : fixedLetters) (n + 1) xs
  else updateFixedLetters fixedLetters (n + 1) xs

lettersCrossedOut :: String -> String -> [Char] -> Bool
lettersCrossedOut [] _ _ = False
lettersCrossedOut (x:xs) word usedLetters =
  (not (contains x word) && contains x usedLetters) ||
  lettersCrossedOut xs word usedLetters

--Generates a wrong color in a list of colors - the answer,
--on a specific position (random Int in range 1 - lengthOfWord)
--Use: hard mode
lieGenerator :: [Color] -> Int -> [Color]
lieGenerator [] _ = []
lieGenerator (x:xs) 1
  | x == Green = Gray : xs
  | x == Yellow = Green : xs
  | otherwise = Yellow : xs
lieGenerator (x:xs) n = x : lieGenerator xs (n - 1)

-----------------------------------------------------------------_HELPER_MODE_-----------------------------------------------------------------

helperMode :: [String] -> [Char] -> [Char] -> [Char] -> Int -> IO ()
helperMode dictionary usedLetters guessedLetters fixedLetters lengthOfWord = do
  let newDictionary = generateNewDictionary dictionary usedLetters guessedLetters fixedLetters

  if null newDictionary
    then putStrLn "No possible words found!"
    else do
      i <- getStdRandom (randomR (0, length newDictionary - 1))
      let guess = newDictionary !! i

      putStrLn $ "My guess is \"" ++ guess ++"\""
      putStrLn "Enter colors (g == Green, y == Yellow, o == Gray): "

      answer <- getLine
      if all (`elem` ['g', 'y', 'o']) answer
        then do
          let newUsedLetters = addLetters guess usedLetters
          let newGuessedLetters = evaluateGuessedLetters guess answer guessedLetters
          let newFixedLetters = evaluateFixedLetters guess answer fixedLetters

          if gameWonHelper answer lengthOfWord
            then putStrLn "We won!"
            else helperMode newDictionary newUsedLetters newGuessedLetters newFixedLetters lengthOfWord
        else do
          putStrLn "Invalid colors! Please use only 'g', 'y', and 'o'"
          helperMode dictionary usedLetters guessedLetters fixedLetters lengthOfWord

-----------------------------------------------------------------------------------------------------------------------------------------------

generateNewDictionary :: [String] -> [Char] -> [Char] -> [Char] -> [String]
generateNewDictionary [] _ _ _ = []
generateNewDictionary (x:xs) usedLetters guessedLetters fixedLetters =
  if isWordCompatible x usedLetters guessedLetters fixedLetters && 
    allLettersIncluded x guessedLetters
    then x : generateNewDictionary xs usedLetters guessedLetters fixedLetters
  else generateNewDictionary xs usedLetters guessedLetters fixedLetters

isWordCompatible :: String -> [Char] -> [Char] -> [Char] -> Bool
isWordCompatible [] _ _ _ = True
isWordCompatible word@(x:xs) usedLetters guessedLetters fixedLetters@(y:ys) =
  (not (contains x usedLetters) || contains x guessedLetters) &&
  (y == '?' || y == x) &&
  isWordCompatible xs usedLetters guessedLetters ys

allLettersIncluded :: String -> [Char] -> Bool
allLettersIncluded _ [] = True
allLettersIncluded word (x:xs) = contains x word && allLettersIncluded word xs

unknownWord :: Int -> String
unknownWord 1 = "?"
unknownWord n = '?' : unknownWord (n - 1)

--g == Green, y == Yellow, o == Gray
evaluateGuessedLetters :: String -> String -> [Char] -> [Char]
evaluateGuessedLetters [] _ z = z
evaluateGuessedLetters _ [] z = z  -- Handle case where answer is empty
evaluateGuessedLetters guess@(x:xs) answer@(y:ys) z
  | y `elem` ['g', 'y', 'o'] = -- Valid input colors
      if (y == 'g' || y == 'y') && not (contains x z)
        then evaluateGuessedLetters xs ys (x : z)
        else evaluateGuessedLetters xs ys z
  | otherwise = z  -- Invalid color input, return unchanged result

evaluateFixedLetters ::  String -> String -> String -> [Char]
evaluateFixedLetters [] _ z = z
evaluateFixedLetters guess@(x:xs) answer@(y:ys) fixedLetters@(z:zs) =
  if y == 'g'
    then x : evaluateFixedLetters xs ys zs
  else '?' : evaluateFixedLetters xs ys zs

gameWonHelper :: [Char] -> Int -> Bool
gameWonHelper _ 0 = True
gameWonHelper (x:xs) n = (x == 'g') && gameWonHelper xs (n - 1)