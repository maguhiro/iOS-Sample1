#
# ヘルプ
#
.PHONY: help
help:
	@ echo '■使い方'
	@ echo '  make setup               # セットアップ'
	@ echo '  make bundle              # bundle install'
	@ echo '  make mint                # mint bootstrap'
	@ echo '  make carthage-bootstrap  # carthage bootstrap'
	@ echo '  make carthage-update     # carthage update'
	@ echo '  make lint                # lintチェック'
	@ echo '  make format              # コードフォーマット'

#
# セットアップ
#
.PHONY: setup
setup: bundle mint carthage-bootstrap

#
# Bundler
#
.PHONY: bundle
bundle:
	bundle install

#
# Mint
#
.PHONY: mint
mint:
	mint bootstrap

#
# Carthage
#
.PHONY: carthage-bootstrap
carthage-bootstrap:
	mint run carthage/carthage carthage bootstrap --platform ios --cache-builds

.PHONY: carthage-update
carthage-update:
	mint run carthage/carthage carthage update --platform ios --cache-builds

#
# SwiftLint
#
.PHONY: lint
lint:
	mint run realm/SwiftLint swiftlint lint

#
# SwiftFormat
#
.PHONY: format
format:
	mint run nicklockwood/SwiftFormat swiftformat . --cache ./cache/swiftformat/cache.swiftformat
