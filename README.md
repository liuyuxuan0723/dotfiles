# mac开发环境的必装清单及配置脚本。

- 常见的应用软件
- 命令行工具
- 开发环境

快速开始

### 应用软件

- [🪜](https://github.com/Clash-Verge-rev/clash-verge-rev/releases)
- [chrome](https://www.google.com/chrome/?brand=FKPE&ds_kid=43700081222624393&gad_source=1&gclid=CjwKCAjwp8--BhBREiwAj7og176VBNdx_nh44ppjIG9Y-UJx_-ifOFELFdtp1oUMC-abHCwhBI1zbhoCjVcQAvD_BwE&gclsrc=aw.ds)
- [typora](https://typoraio.cn/)
- [vscode](https://code.visualstudio.com/)
- [cursor](https://www.cursor.com/cn)
- [goland](https://www.jetbrains.com/go/)
- [poe](https://poe.com/login)
- [docker](https://www.docker.com/products/docker-desktop/)
- [lark](https://www.feishu.cn/)
- [wechat](https://weixin.qq.com/)
- [iterms](https://iterm2.com/downloads.html)
- navicate
- postman

### 命令行工具

- [brew](https://brew.sh/)

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- [git](https://git-scm.com/)

```shell
brew install git

git config --global user.name "liuyuxuan"
git config --global user.email "liuyuxuan7723gmail.com"

ssh-keygen -t rsa -b 4096 -C "liuyuxuan7723gmail.com"
cat ~/.ssh/id_rsa.pub
```

- [oh-my-zsh](https://ohmyz.sh/#install)

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

- [powerlevel10k](https://github.com/romkatv/powerlevel10k)

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

- zsh-autosuggestions && zsh-syntax-highlighting

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- [kubectl](https://kubernetes.io/docs/reference/kubectl/)

```shell
brew install kubernetes-cli
```

- [K9s](https://k9scli.io/)

```shell
brew install k9s
```

- [kube-ps1](https://github.com/jonmosco/kube-ps1): 显示当前K8s context

```shell
brew update
brew install kube-ps1
```

- [yq](https://github.com/mikefarah/yq) : 啥都能解

```shell
brew install yq
```

- [kubecm](https://github.com/sunny0826/kubecm): 多集群kubeconfig管理

```shell
brew install kubecm
```

### 开发环境

- [miniconda](https://www.anaconda.com/docs/getting-started/miniconda/main)

```shell
brew install --cask miniconda
```

- [golang](https://github.com/voidint/g)：使用 g 工具进行多版本管理

```shell
# It is recommended to clear the `GOROOT`, `GOBIN`, and other environment variables before installation.
curl -sSL https://raw.githubusercontent.com/voidint/g/master/install.sh | bash
cat << 'EOF' >> ~/.zshrc
# Check if the alias 'g' exists before trying to unalias it
if [[ -n $(alias g 2>/dev/null) ]]; then
    unalias g
fi
EOF 
source "$HOME/.g/env"
```

- [node](https://github.com/tj/n)

```shell
curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts
# If you want n installed, you can use npm now.
npm install -g n
```

- [Java](https://github.com/shyiko/jabba): 这个工具没用过，但是先列着

```shell
export JABBA_VERSION=...
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
```

## 配置脚本

### 一键安装各种工具脚本

```shell
./brew.sh
./config.sh
./syncRemote.sh
./syncLocal.sh
```

### dotfile同步到本地仓库

- 同步时注意修改哪些需要同步
- 超过2MB的文件夹限制了无法同步

```shell
./syncToRemote.sh
```

### 远端仓库配置同步到本地dotfile

```shell
./syncToLocal.sh
```

```shell
on run {input, parameters}
	-- 检查iTerm2是否已经打开
	tell application "System Events"
		set isRunning to (count of (every process whose name is "iTerm2")) > 0
	end tell

	-- 如果iTerm2没有运行，则启动它并创建一个新窗口
	if not isRunning then
		tell application "iTerm"
			activate
			create window with default profile
		end tell
	else
		-- 如果iTerm2已经运行，切换到它并创建一个新窗口（如果需要）
		tell application "iTerm"
			activate
			if (count of windows) = 0 then
				create window with default profile
			end if
		end tell
	end if

	return input
end run
```
