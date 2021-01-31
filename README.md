# 使用说明

打开 `~/.zshrc` 文件，并增加以下配置

```sh
plugins=(ai-chan)
```

进入自定义目录

```sh
cd $ZSH_CUSTOM
```

按照以下方式组织文件

```sh
$ZSH_CUSTOM
└── plugins
    └── ai-chan
        └── ai-chan.plugin.zsh
```

# 原理

* [检测 bitcode](https://ai-chan.top/code/detect-bitcode)