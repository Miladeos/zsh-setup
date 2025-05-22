# Ultimate ZSH Setup Script

This script automates the installation and configuration of a powerful ZSH environment, designed to improve your productivity and provide a better user experience in the terminal. Say goodbye to tedious manual setup and hello to a feature-rich, visually appealing, and highly efficient command-line interface.

## ✨ Features

This setup includes a curated selection of tools and plugins to supercharge your ZSH experience:

- **Oh My ZSH**: An open-source, community-driven framework for managing your ZSH configuration. It comes with thousands of helpful functions, helpers, plugins, themes, and a few things that make you shout... "Oh My ZSH!"
- **Powerlevel10k**: A fast and flexible ZSH theme with a slick look and useful information displayed promptly. It's highly customizable and offers an excellent out-of-the-box configuration.
- **Syntax Highlighting**: Provides real-time highlighting of commands and syntax as you type, helping to catch errors before execution.
- **Auto-suggestions**: Suggests commands as you type based on your history and completions, speeding up your workflow.
- **Fuzzy Finder (fzf)**: A command-line fuzzy finder that allows for quick and intuitive searching of files, command history, processes, and more.
- **zsh-completions**: Additional completion definitions for ZSH, enhancing the default tab-completion capabilities for many common tools.
- **Additional Plugins**:
    - `history`: Provides improved history navigation.
    - `colored-man-pages`: Adds color to man pages for better readability.
    - `command-not-found`: Suggests packages to install if a command is not found.
    - `sudo`: Easily prepend `sudo` to the current or previous command by pressing `Esc` twice.
    - `copypath`: Copies the absolute path of the current directory or a specified file to the clipboard.
    - `docker`: Adds autocompletion for docker commands and aliases.
- **Useful Aliases**: A collection of pre-configured aliases for common commands to save you time and keystrokes.

## 📦 Installation

**Important**: Before running any script from the internet, it's a good practice to inspect its content to understand what it does.

To install, clone the repository and run the script:
```bash
git clone https://github.com/Miladeos/zsh-setup.git && cd zsh-setup && chmod +x zshell.sh && ./zshell.sh -y
```

## 🚀 Usage

The `zshell.sh` script accepts the following command-line options:

-   `-h, --help`: Display the help message, showing available options and their descriptions.
-   `-y, --yes`: Skip all confirmation prompts and run in non-interactive mode. Useful for automated setups.
-   `-q, --quiet`: Minimal output. Only essential error messages and a final success or failure message will be displayed.
-   `-v, --verbose`: Show detailed output of all operations being performed. This is useful for debugging issues with the script.

**Examples:**

-   Run the script with default behavior (will prompt for confirmations):
    ```bash
    ./zshell.sh
    ```
-   Run in non-interactive mode (accept all defaults):
    ```bash
    ./zshell.sh -y
    ```
-   See all the steps the script is performing:
    ```bash
    ./zshell.sh -v
    ```

## 🛠️ Customization

Once the script has finished, your ZSH environment is ready to go, but you can further customize it to your liking:

-   **ZSH Configuration**: The main configuration file for ZSH is `~/.zshrc`. You can edit this file to change settings, add or remove plugins, modify aliases, and more.
-   **Powerlevel10k Theme**: To reconfigure the Powerlevel10k theme, run the command `p10k configure` in your terminal. This will guide you through the customization process, allowing you to change prompts, icons, and other visual aspects.
-   **Oh My ZSH Plugins**:
    -   To **add** a plugin, find its name (e.g., `newplugin`) and add it to the `plugins=(...)` list in your `~/.zshrc` file. For example: `plugins=(git docker newplugin)`
    -   To **remove** a plugin, simply delete its name from the `plugins=(...)` list in `~/.zshrc`.
    Remember to source your `~/.zshrc` file (e.g., by running `source ~/.zshrc`) or open a new terminal window for changes to take effect.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Miladeos/zsh-setup/issues).

If you'd like to contribute, please:
1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
