# 需要配置git config 后执行

# 自动补全和高亮
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# powerlevel10k，注意安装字体
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# golang 版本管理，需要做 g 的别名管理
curl -sSL https://raw.githubusercontent.com/voidint/g/master/install.sh | bash

# node版本管理
sudo curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s install lts
# If you want n installed, you can use npm now.
sudo npm install -g n