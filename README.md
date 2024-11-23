# Chess-EP


FPGA Chess Game on Basys 3 (In Development)
Description
This project is an in-progress implementation of a basic chess game on the Basys 3 FPGA development board. The game features interaction via a PS/2 keyboard for player inputs and displays the game board and movements on a VGA display. It aims to demonstrate the use of FPGA for real-time gaming applications while exploring hardware design challenges.

Features (Planned/Implemented)
Player Interaction: Input chess moves using a standard PS/2 keyboard (in progress).
VGA Output: Display the chessboard and pieces on a VGA monitor in real-time (basic implementation completed).
Piece Movement Validation: Basic logic to enforce valid chess moves (in development).
Turn Management: Alternating turns between two players (in progress).
Reset Functionality: Ability to reset the board to the initial state (basic implementation completed).
⚠️ Note:
This project is actively under development. Some features and functionalities may not yet be fully implemented or optimized.

Hardware Requirements
Basys 3 FPGA Development Board
Artix-7 FPGA
Onboard VGA port and PS/2 keyboard interface
PS/2 Keyboard
VGA Monitor
Implementation Details
Modules (In Development)
The project is modular and includes the following components:

Keyboard Interface:
Captures input from the PS/2 keyboard, decodes scancodes, and translates them to chess moves (under testing).

VGA Controller:
Renders the chessboard and pieces to a VGA display (basic version implemented).

Game Logic:
Implements rules for chess movement validation, turn switching, and game state management (basic logic in progress).

Top-Level Module:
Integrates all subsystems and manages overall system flow (work in progress).

Current Limitations:

Advanced chess rules (e.g., en passant, castling) are not implemented.
Check/checkmate detection is not yet available.
Movement validation logic is incomplete for complex cases.
