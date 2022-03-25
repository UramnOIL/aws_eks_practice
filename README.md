# AWSを学習するためのプロジェクト

EKSをベースに、Kubernetes・Helm・Terraformを使ってIaCを実現したい。

Kubernetesのmanifestは別リポジトリで管理する。

ついでにGitについて再履修もする。

gitmojiではなくprefixを使う。

git logをきれいにする。
[参考](https://www.granfairs.com/blog/cto/git-merge-squash)

## ArgoCDに接続する

```sh
$ kubectl port-forward svc/argocd-server -n argocd 8080:443
```

![ArgoCD Login Form](/images/argocd_login.png)

User: `admin`

Password: `$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

## Application

- https://github.com/UramnOIL/kubernetes_practice

![guestbook](/images//guestbook-ui.png)


## modules

Moduleを管理するディレクトリ。
わざわざModuleにまとめるほどの抽象度を設ける必要はないが、環境別で設定を変えたいときのために用意した。

### eks

AWS EKSの構築。

[](/modules/kes/README.md)

### vpc

AWS VPCの構築。

[](/modules/vpc/README.md)

### kubernetes

Kubernetes関連の設定。
Helmのデプロイも併せて行う。

[](/modules/kubernetes/README.md)

## 課題

### 適切なインスタンスタイプとmin/max/desiredサイズがわからない

ArgoCDでデプロイされるPodの数が6個と多いので、t2.micro x2だとPodの制限に引っかかる。
今は多めに確保してt2.small x2(x4)で動かしている。

### AWSの各サービスの内容がいまいち掴めていない

#### IAM

あらかじめ用意されているポリシーを適用したIAMを使っても、権限が足りないと怒られる。怒られたら都度必要になった権限を追加している状況。

#### VPC

AZやサブネットが用意されているが、KubernetesのNodeやPodの関係がよくわからない。