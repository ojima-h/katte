# Katte

Katte は以下の特徴を備えたバッチ処理管理ツールです。

- 実行可能なタスク定義
- タスクの依存関係の解決
- 実行コマンドや出力コマンドを拡張可能

## Installation

Add this line to your application's Gemfile:

    gem 'katte'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install katte

## Turtorial

### はじめの一歩

`recipes/` 以下にタスクの定義を記述します。

    $ vim recipes/first_task.sh

    echo ${date}

`$ bin/katte run -d yyyy-mm-dd` を実行すると、`result/first_task.log` 以下
に結果が出力されます。

拡張子から実行コマンドを判別します。
実行コマンドは、bash(.sh) / ruby(.rb) / Rscript(.R) / hive(.sql) をデ
フォルトでサポートしています。

### 実行オプションを記述する

レシピの先頭に実行オプションを記述できます。

    # require: second_task
    # output : file, stdio
    # period : week

    echo good day

オプションの意味は以下の通りです。

<dl>
  <dt>`require`</dt><dd>指定したタスクの完了を待って実行します。タスクは
  `recipes/` からの相対パスで指定します。</dd>
  <dt>`output`</dt><dd>出力方法を指定します。デフォルトで `file` と
  `stdio` が指定可能です。</dd>
  <dt>`period`</dt><dd>実行周期を指定します。`day` / `week` / `month`
  が指定可能です。</dd>
</dl>

### 実行コマンドを拡張する

`Katte::Plugins::FileType` を継承したクラスをロードすることで、実行コ
マンドを拡張できます。

`Katte::Plugins::Output` を継承したクラスをロードすることで、出力方法を
拡張できます。

記述例は `lib/katte/plugins/file_type/bash.rb` /
`lib/katte/plugins/output/file.rb` を参考にしてください。

### カスタムレシピを記述する

rubyレシピに `custom` オプションを指定することで、タスクの実行タイミン
グを柔軟に制御することができます。

    $ vim custom_recipe.rb

    # option: custom
    loop {
      if FileTest.file?('/some/important/file')
        tag 'important'
        break
      elsif FileTest.file?('/some/critical/file')
        tag 'critical'
        break
      end
      sleep 1000
    }

    done

    $ vim custom_recipe/sub_task.sh

    # require: custom_recipe:important
    cat /some/important/file

`tag <tag>` で次のタスクの実行を開始します。
`done` でこのタスクの実行を終了します。

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
