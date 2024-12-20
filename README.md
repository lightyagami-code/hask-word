# HaskWord

An enhanced implementation of word game in terminal using Haskell featuring multiple game modes and an AI assistant.

## Features

- 🎮 Multiple Game Modes:
  - Easy Mode: Letters used, valid word checks, no penalty for errors
  - Standard Mode: Classic Wordle experience
  - Hard Mode: One misleading hint per game
- 🤖 Assistant Mode: Let the AI solve your Wordle puzzles
- 📏 Customizable word length
- 📚 Extensive dictionary support

## Video Demo
[Haskword Demo](https://drive.google.com/file/d/1RVRa-sXLPdZmY8wYVK5hGOBKNPZ1aGeo/view?usp=sharing)

## Installation Guide

### Windows

1. Install GHCup (Haskell toolchain installer):
   - Download the installer from [GHCup Website](https://www.haskell.org/ghcup/)
   - Run the installer and follow the prompts
   - Select GHC 9.4.7 and Cabal 3.0 or later during installation

2. Clone or download the repository:
```cmd
git clone https://github.com/lightyagami-code/hask-word.git
cd hask-word
```

3. Verify installation:
```cmd
ghc --version
cabal --version
```

### Linux

1. Install GHCup and required tools:
```bash
# Install system dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install build-essential curl libgmp-dev libffi-dev libncurses-dev

# Install GHCup
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Add GHCup to PATH (add to your .bashrc or .zshrc)
export PATH="$HOME/.ghcup/bin:$PATH"
```

2. Clone the repository:
```bash
git clone https://github.com/lightyagami-code/hask-word.git
cd hask-word
```

## Building and Running

1. Update Cabal package list:
```bash
cabal update
```

2. Build the project:
```bash
cabal build
```

3. Run the game:
```bash
cabal run
```


## Game Rules & Modes

### 🎮 Game Mode

In Game Mode, you try to guess a hidden word. The game offers three difficulty levels:

#### 1. Easy Mode
- You get 6 attempts to guess the word
- Helpful features:
  - Shows all letters you've already used
  - Displays which letters are definitely in the word
  - Shows correctly placed letters' positions
  - Prevents using letters already marked as not in the word
  - Prevents making guesses that don't use already discovered correct letters
  - All guesses must be valid dictionary words
- Perfect for learning the game mechanics and practicing

#### 2. Standard Mode (Classic)
- 6 attempts to guess the word
- Features:
  - Standard color feedback only (🟩, 🟨, ⬜)
  - Must be valid dictionary words
  - No additional hints or restrictions

#### 3. Hard Mode
- 6 attempts to guess the word
- Additional challenge:
  - One randomly chosen feedback during the game will be intentionally wrong
  - The lie will change one square's color to a different color
  - You won't know which guess contains the lie
  - Must be valid dictionary words
- Tests your deduction skills and ability to spot inconsistencies

### Color Feedback System
For all modes:
- 🟩 Green: Correct letter in correct position
- 🟨 Yellow: Letter exists in word but wrong position
- ⬜ Gray: Letter not in word at all

### 🤖 Assistant Mode

A helper mode designed to assist you in solving Wordle puzzles from any source:

#### How to Use
1. Start playing any Wordle puzzle you want help with
2. Tell the assistant your puzzle's word length
3. The assistant will suggest words to try
4. After each suggestion:
   - Enter the suggested word in your actual Wordle game
   - Look at the colored squares you get
   - Translate the colors to letters for the assistant:
     - 'g' for 🟩 (Green)
     - 'y' for 🟨 (Yellow)
     - 'o' for ⬜ (Gray)
   - Example: 
     - If you see: 🟩⬜🟨🟨⬜
     - Type: 'goyyo'

#### Assistant Strategy
- Uses an intelligent algorithm to:
  - Track all possible remaining words
  - Eliminate impossible words based on feedback
  - Suggest optimal guesses to narrow down possibilities
- Always suggests valid dictionary words
- Learns from each guess to make better subsequent suggestions

## Example Game Sessions

### Standard Mode Example:
```
Select mode ('game', 'helper'): game
Select difficulty ('standard'): standard
Enter word length: 5
Enter guess (Attempts left: 6): smart
🟨⬜🟩⬜🟨
Enter guess (Attempts left: 5): trace
🟩⬜🟩⬜⬜
...
```

### Easy Mode Example:
```
Select mode ('game', 'helper'): game
Select difficulty ('easy'): easy
Enter word length: 5
Currently used letters: 
Enter guess (Attempts left: 6): smart
🟨⬜🟩⬜🟨
Currently used letters: s m a r t
Currently guessed letters: s a t
Currently fixed letters: _ _ a _ t
...
```

### Hard Mode Example:
```
Select mode ('game', 'helper'): game
Select difficulty ('hard'): hard
Enter word length: 5
Enter guess (Attempts left: 6): smart
🟨⬜🟩⬜⬜  (This could be the lie!)
...
```

### Assistant Mode Example:
```
Select mode ('game', 'helper'): helper
Enter word length: 5
My guess is "smart"
Enter colors (g == Green, y == Yellow, o == Gray): goyyo
My next guess is "stare"
...
```

## Requirements

### Windows
- Windows 10 or later
- GHC 9.4.7 or later
- Cabal 3.0 or later
- UTF-8 compatible terminal

### Linux
- Any modern Linux distribution
- GHC 9.4.7 or later
- Cabal 3.0 or later
- Basic build tools (gcc, make)
- UTF-8 compatible terminal

## Project Structure
```
haskword/
├── app/
│   └── Main.hs       # Main game logic
├── dictionary.txt    # Word dictionary
└── project.cabal
```

## Troubleshooting

### Windows
- If emojis don't display correctly, ensure your terminal supports UTF-8 and run:
  ```cmd
  chcp 65001
  ```

### Linux
- If dictionary file is not found, ensure it's in the same directory as the executable
- For terminal encoding issues:
  ```bash
  export LANG=en_US.UTF-8
  ```

