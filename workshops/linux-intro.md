---
layout: default
---

# Introduction to the Linux Shell

### Connecting to WiFi 

Connect to the network: `workshop`

### Connect to the SCC

1. (Windows): Windows: start [MobaXterm](http://mobaxterm.mobatek.net/download-home-edition.html)

    ![MobaXterm on Windows](http://mobaxterm.mobatek.net/img/slider/MobaXterm.png)

 - Mac: open `Terminal`. (Use spotlight, upper right-hand corner search bar, to find
   it.)

![Terminal on Mac](http://web.mit.edu/music21/doc/_images/macScreenPythonVersion.png)

2. Type `ssh test_user@login.scc.camh.net`

3. Use the password: `work shop` (yes, there is a space)

4. Make a folder for yourself: 

    ```sh
    mkdir jon_pipitone
    cd jon_pipitone
    ```

5. Download the workshop data: 

    ```sh
    wget http://swcarpentry.github.io/shell-novice/shell-novice-data.zip
    unzip shell-novice-data.zip
    cd data
    ```
