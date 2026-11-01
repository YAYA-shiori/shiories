# SHIORIES

SHIORI たちが擬人化して、ゴーストを動かす舞台裏を語る伺か（ukagaka）のゴーストです。

- 2006 年に、華和梨 8 とミドルウェア OpenKEEPS で作られました。
- **このリポジトリは、SHIORI を YAYA 6 コアに組み直した版**です。辞書は新しく組み立て、シェルは元のままです。
- 配布元: http://ms.shillest.net/

## GitHub からダウンロードする方へ

nar は https://yaya-shiori.github.io/shiories/ からダウンロードしてください。このリポジトリを zip で取得しても不完全です（`ghost/master/dic/system` が空になります）。
ネットワーク更新も同じ場所から配られます。push のたびに GitHub Actions（`.github/workflows/auto_deploy.yml`）が、nar と更新ファイルを作って公開します。

## 改造のしかた

- 辞書の本体は `ghost/master/dic/normal/` にある `.dic` ファイルです。文字コードは UTF-8（BOM なし）です。
- どのファイルに何が書いてあるか、キャラクターと使えるサーフェス番号、トークの書き方の決まりは、[GHOST.md](GHOST.md) にまとめてあります。
- 詳しい仕様は、次を見てください。
  - YAYA の文法と関数: yaya-docs（https://yaya-shiori.github.io/yaya-docs/ ）
  - さくらスクリプト、SHIORI イベント、設定ファイル: UKADOC（https://ssp.shillest.net/ukadoc/manual/ ）
- 辞書にエラーがあると、ゴーストは緊急モードで起動し、ほとんど話さなくなります。
- シェル（`shell/master/`）の画像は編集しないでください。

## AI エージェントで開発する

AI コーディングエージェントで開発するときは、スキル [ukagaka-developer](https://github.com/ukatech/ukagaka-developer) が使えます。辞書の書き方、エラーのチェック、SSP での動作確認、nar の作成を手伝ってくれます。入れたら、「セットアップして」と頼んでください。ゴーストに固有の情報は [GHOST.md](GHOST.md) にあります。

## ライセンス

- ゴースト（辞書）: 著作権者は「整備班」、ライセンスは クリエイティブ・コモンズ 表示 2.5（`readme.txt`）。
- シェル: ボトル猫氏の作品です。
- YAYA（`yaya.dll`、`ghost/master/dic/system`）: それぞれのリポジトリのライセンスに従います。
