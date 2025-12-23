# Domain-Geo-Checker
Simple shell script for looking up GEO IP data from RIPEstat by domain name. 

Script takes a domain name as input, resolves it into IPv4 addresses and looks up each address via [RIPEstat API endpoints](https://stat.ripe.net/docs/data-api/ripestat-data-api). Country and city comes from maxmind geolite source if available, otherwise RIR Geo endpoint is used.

## Dependencies
- `jq`
- `curl`

## Example usage

```shell
bash checker.sh api.github.com
Results for domain: api.github.com
-------------------------------------------------------------------------
IP              | Country  | City              | ASN      | Holder
-------------------------------------------------------------------------
140.82.121.5    | DE       | Frankfurt am Main | 36459    | GITHUB
-------------------------------------------------------------------------
```

```shell
bash checker.sh ozon.ru
Results for domain: ozon.ru
-------------------------------------------------------------------------
IP              | Country  | City            | ASN      | Holder
-------------------------------------------------------------------------
185.73.194.82   | RU       | -               | 44386    | OZON-AS - LLC Internet Solutions
185.73.193.68   | RU       | -               | 44386    | OZON-AS - LLC Internet Solutions
-------------------------------------------------------------------------
```
