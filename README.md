# OpenAI-Checker
Used to check if your IP can access OpenAI services.

> [!IMPORTANT]  
> **With the update of OpenAI's strategy, this script may no longer be accurate. (May 29, 2023)**

## Detection method
Our detection results come from **Cloudflare** and the accuracy is independent of this script.   

At present, there are 163 countries supported, and I will continue to update the countries and regions newly supported by OpenAI. (April 5, 2023)

## Usage
```shell
bash <(curl -Ls (https://raw.githubusercontent.com/ecyecy/OpenAI-Checker/main/openai.sh))
```
## Result
```
> bash <(curl -Ls https://cpp.li/openai)
OpenAI Access Checker. Made by Vincent
https://github.com/missuo/OpenAI-Checker
-------------------------------------
[IPv4]
Your IPv4: 205.185.1.1 - FranTech Solutions
Your IP supports access to OpenAI. Region: US
-------------------------------------
[IPv6]
Your IPv6: 2401:95c0:f001::1 - Vincent Yang
Your IP supports access to OpenAI. Region: TW
-------------------------------------
```
## Thanks
- [Hill-98](https://github.com/Hill-98): Improved the Loc Code that can support access to OpenAI. [#1](https://github.com/missuo/OpenAI-Checker/issues/1)

## Author
**OpenAI-Checker** © [Vincent Young](https://github.com/missuo), Released under the [MIT](./LICENSE) License.<br>
