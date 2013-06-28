## ethnaの関連ファイル編集をサポートするためのプラグイン

### 1. 参考元
**vim-php-ethna-jump**

https://github.com/hk4nsuke/vim-php-ethna-jump.vim

### 2. 使い方
#### 2.1 関連ファイルを開く
ethna backend ファイルを開いている時は backend の、frontend ファイルを開いている時は frontend の関連ファイルを Unite バッファに表示します
```vimrc
:Unite ethna 編集中ファイルの関連ファイルを開く

お好みでマッピングして下さい (例)
nnoremap <leader>ue :Unite ethna<CR>
```

#### 2.2 関連ファイルの定義
* backend - TdGateway, GenericDao, Module
* fronted - act, view, tpl

### 3. ToDo
#### 3.1 Module <-> Test の関連付け
