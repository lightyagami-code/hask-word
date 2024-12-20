# HaskWord

An enhanced implementation of word game in Haskell featuring multiple game modes and an AI assistant.

## Features

- 🎮 Multiple Game Modes:
  - Easy Mode: Letters used, valid word checks, no penalty for errors
  - Standard Mode: Classic Wordle experience
  - Hard Mode: One misleading hint per game
- 🤖 Assistant Mode: Let the AI solve your Wordle puzzles
- 📏 Customizable word length
- 📚 Extensive dictionary support

## Installation Guide

### Windows

1. Install GHCup (Haskell toolchain installer):
   - Download the installer from [GHCup Website](https://www.haskell.org/ghcup/)
   - Run the installer and follow the prompts
   - Select GHC 9.4.7 and Cabal 3.0 or later during installation

2. Clone or download the repository:
```cmd
git clone [your-repository-url]
cd wordle-haskell
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

2. Install specific GHC version and Cabal:
```bash
ghcup install ghc 9.4.7
ghcup install cabal 3.0.0.0
ghcup set ghc 9.4.7
```

3. Clone the repository:
```bash
git clone [your-repository-url]
cd wordle-haskell
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

## How to Play

### Game Mode
1. Select "game" when prompted for mode
2. Choose difficulty:
   - Easy: Shows used letters, validates words, no penalties
   - Standard: Classic Wordle rules
   - Hard: One intentionally misleading hint per game
3. Enter word length when prompted
4. Make your guesses and receive feedback:
   - 🟩 Green: Correct letter, correct position
   - 🟨 Yellow: Correct letter, wrong position
   - ⬜ Gray: Letter not in word

### Assistant Mode
1. Select "helper" when prompted for mode
2. Enter the length of your secret word
3. The AI will make guesses
4. Provide feedback using:
   - 'g' for Green (correct position)
   - 'y' for Yellow (wrong position)
   - 'o' for Gray (not in word)

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
wordle-haskell/
├── app/
│   └── Main.hs       # Main game logic
├── dictionary.txt    # Word dictionary
├── cabal.project
└── wordle.cabal
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

