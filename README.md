＃ Terraformサンプル

Terraformを利用してEC2のインスタンスを起動してSSHで接続できるようにします。

## 手順

### terraform のインストール

```
$ yay -Sy terraform
```

## SSHキーペアの作成

```
$ cd iac
$ ssh-keygen -t rsa
```

> Enter file in which to save the key (/home/xxxxx/.ssh/id_rsa): ./id_rsa

./id_rsaでiacディレクトリ直下にキーを作成します

## terraformの実行

初回のみ初期化をします

```
$ terraform init
```

プランして

```
$ terraform plan
```

実行

```
$ terraform apply

...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

...

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

public_ip = "xxx.xxx.xxx.xxx"
```

実行していいか聞かれるので`yes`を入力してエラーなく終了すると
EC2インスタンスのIPアドレスが表示されるのでそれを使ってSSH接続します。

## ssh接続

```
ssh -i ./id_rsa ubuntu@xxx.xxx.xxx.xxx
```
