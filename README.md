# speedtest-ifttt
Run `speedtest-cli` within docker and append to Google Sheet through IFTTT <br/>

## Install:
1. Install dependencies:
    - [Docker](https://docs.docker.com/install/)
    - [tianon/speedtest](https://hub.docker.com/r/tianon/speedtest/): `docker pull tianon/speedtest`
1. Configure IFTTT:
    - Example Webhook Applet: https://ifttt.com/applets/379108p-log-speedtest-results-to-spreadsheet
    - Retrieve IFTTT Secret: https://ifttt.com/services/maker_webhooks/settings (i.e. `https://url/use/<secret>`)
    - Configure secret in script `secret_key="<secret-key>"`
1. Run speed test & verify results:
    - `./speedtest-ifttt.sh`
    - Add columns to newly created google sheet: `Sheet columns: "Date,Ping,Download (Mbps),Upload (Mbps)"`
1. Configure to run periodically with crontab:
    - For example, every 4 hours: `0 */4 * * * /path/to/speedtest-ifttt.sh`
    
## Example Results:
|Date|Ping|Download (Mbps)|Upload (Mbps)|
| --- | --- | --- | --- |
|May 13, 2018 at 02:00PM	|18.684 Mbps	|5.06 Mbps	|64.48|
|May 13, 2018 at 06:00PM	|18.684 Mbps	|9.03 Mbps	|24.67|
|May 13, 2018 at 10:00PM	|21.443 Mbps	|18.04 Mbps	|31.08|
