# Livepeer for HiveOS

This is a *custom miner* HiveOS for livepeer - https://github.com/livepeer/go-livepeer

### Usage

Only extra config arguments are used by livepeer, other are purely informational.

* Coin `ETH` (Can choose something else)
* Miner Name `livepeer`
* Installation URL `https://github.com/Keybouh/Livepeer-HiveOS/releases/download/v1.0.0/livepeer.tar.gz`
* Hash Algorithm `----`
* Wallet and worker template `%WAL%`
* Pool url `null`
* Pass `x`
* Extra config arguments: See at https://docs.livepeer.org/video-miners/reference/configuration

Example for standalone transcoder: `-transcoder -orchAddr <IP_ORCHESTRATOR>:<PORT_ORCHESTRATOR> -orchSecret <SECRET_ORCHESTRATOR>`
* `-orchAddr` is used to specify the publicly accessible address that the orchestrator is receiving transcoder registration requests at
* The value for `-orchSecret` should be the same as the value used for your orchestrator

Example for combined orchestrator/transcoder: `-orchestrator -transcoder -network arbitrum-one-mainnet -ethUrl https://arbitrum-mainnet.infura.io/v3/<PROJECT_ID> -pricePerUnit <PRICE_PER_UNIT> -serviceAddr <SERVICE_ADDR>`
* Use both the `-orchestrator` and `-transcoder` flags to configure the node to be an orchestrator and a transcoder; it will receive video from broadcasters, transcode the video itself, and return the transcoded results to the broadcasters
* `-pricePerUnit` is used to specify the price (wei per pixel) for transcoding. The flag is required on startup, but the value can be changed later
* `-serviceAddr` is used to specify the publicly accessible address that the orchestrator should receive requests at. Changing this requires a blockchain transaction, so it's preferable to use a hostname for a domain you own, not an IP address that may change

### Update miner

This miner automatically checks the new version and update at each restart.

The current version is saved on a file version. If you want to reinstall you can delete this file: `rm /hive/miners/custom/livepeer/version`

### Donation

ETH 0xf4b563682C2d07A33EEc5EF3Aae2052070ea2445
