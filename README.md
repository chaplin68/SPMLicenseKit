# SPMLicenseKit

SPMLicenseKitは、Swift Package Manager (SPM) で管理されているライブラリの情報とライセンス情報を自動的に取得するSwiftパッケージ。

## 特徴

- **自動パス検出**: ビルド時にworkspace-state.jsonとDerivedDataの場所を自動的に検出
- **ライセンス情報の取得**: 各SPMライブラリのライセンステキストを取得
- **プラグイン統合**: Swift Package Managerのプラグインを活用して環境に依存しないパス検出

## インストール方法

### Swift Package Manager

Package.swiftに以下を追加してください:

```swift
dependencies: [
    .package(url: "https://github.com/chaplin68/SPMLicenseKit.git", from: "1.0.0")
]
```

## 使い方

### 基本的な使い方

最も簡単な使い方は、自動パス検出を利用する方法です。

```swift
import SPMLicenseKit

// ライセンス情報を読み込み
SPMLicense.libraries.forEach { license in
  print("Name: \(library.name)")
  print("License: \(library.licenseBody ?? "")")
}
```
## ライセンス

このライブラリはMITライセンスのもとで提供されています。詳細はLICENSEファイルを参照してください。
