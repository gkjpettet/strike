# strike
Command line static site generator written in Xojo

## Installation
`strike` is a command line tool. To install, you have a few choices:

### 1. Use a package manager (easiest)
Simple installation with Homebrew and Scoop is offered for macOS and Windows users.

**macOS**  
If you're using macOS you can use the excellent [Homebrew][homebrew] package manager to quickly install strike:
```
brew tap gkjpettet/homebrew-strike
brew install roo
```

You can make sure that you've always got the latest version of strike by running `brew update` in the Terminal. You'll know there's an update available if you see the following:

```bash
==> Updated Formulae
gkjpettet/strike/strike ✔
```

Then you'll know there's a new version available. To install it simply type `brew upgrade` in the Terminal. 

**Windows**  
If you're using Windows I recommend using [Scoop][scoop] to install strike. Once You've setup Scoop, simply type the following into the Command Prompt or the Powershell:

```bash
scoop bucket add strike https://github.com/gkjpettet/scoop-strike
scoop install strike
```

To update strike run the following commands:

```bash
scoop update
scoop update strike
```