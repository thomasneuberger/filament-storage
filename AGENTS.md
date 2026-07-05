# Agent instructions

## General
- Documentation for the project is in the /docs folder.
    - The parts list is found in [/docs/Parts.md] and edited manually. It may never be edited by an AI agent.
    - There could be a subfolder localOnly where can find documentation about the devices.
- The software code for this project is in the /src folder.

## Software
The software is developed in VS Code with Platform IO installed.

For each device connection, there should be a separate file that contains the code to read from and write to that device. The main file should only be there for orchestration.