# Activating Software Modules
We can define which software will be able to the users with the `AvailableSoftware` directive. 
The syntax is as follows:
- `SoftwareId|SoftwareId|...`

Each ID is composed by `Category/PackageName`

### Example
An example of a working directive for software is:
```txt
AvailableSoftware=internet/chromium|langs/g++
```
This will result on Chromium and the g++ compiled being activated on huronOS.

## List of Packages
This is a list of available packages in a default installation:

| Software ID                 | Category    | Name               | Software |
| --------------------------- | ----------- | ------------------ | -------- |
| `internet/chromium`         | internet    | chromium           | Chromium |
| `internet/crow`             | internet    | crow               | Crow Language Dictionary App |
| `internet/firefox`          | internet    | firefox            | Firefox Browser |
| `langs/dotnet`              | langs       | dotnet             | C# dotnet compiler (Microsoft) |
| `langs/mono`                | langs       | mono               | C# mono open compiler |
| `langs/g++`                 | langs       | g++                | GNU C++ compiler |
| `langs/gcc`                 | langs       | gcc                | GNU C compiler |
| `langs/javac`               | langs       | javac              | Open JDK Java compiler |
| `langs/kotlinc`             | langs       | kotlinc            | JetBrains Kotlin compiler |
| `langs/pypy3`               | langs       | pypy3              | Pypy 3 python compiler |
| `langs/python3`             | langs       | python3            | Python 3 interpreter |
| `langs/ruby`                | langs       | ruby               | Ruby interpreter |
| `tools/byobu`               | tools       | byoubu             | Byoubu |
| `tools/konsole`             | tools       | konsole            | KDE konsole |
| `tools/midnight-commander`  | tools       | midnight-commander | Midnight-Commander
| `programming/atom`          | programming | atom               | Atom |
| `programming/codeblocks`    | programming | codeblocks         | Code::Blocks |
| `programming/eclipse`       | programming | eclipse            | Eclipse |
| `programming/emacs`         | programming | emacs              | Emacs |
| `programming/geany`         | programming | geany              | Geany |
| `programming/gedit`         | programming | gedit              | gedit |
| `programming/gvim`          | programming | gvim               | gvim |
| `programming/intellij`      | programming | intellij           | IntelliJ |
| `programming/joe`           | programming | joe                | Joe |
| `programming/kate`          | programming | kate               | Kate |
| `programming/kdevelop`      | programming | kdevelop           | KDevelop |
| `programming/pycharm`       | programming | pycharm            | Pycharm |
| `programming/sublime`       | programming | sublime            | Sublime Text |
| `programming/vim`           | programming | vim                | Vim |
| `programming/vscode`        | programming | vscode             | Vscode (Codium) |
| `programming/rider`         | programming | rider              | Rider |

### Documentation
The reference documents for the langs are included in each language package. 
For example, the `langs/g++` package does include the C++ Reference.