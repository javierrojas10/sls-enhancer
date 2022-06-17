# Serverless Framework deploy function enhancer
Bash Script to enhance the Serverless Framework deploy function

## Demo
![ezgif com-gif-maker](https://user-images.githubusercontent.com/46604653/174323658-42938e05-257a-43db-9814-97298d8e2d3b.gif)

## Reqs
As *.yml files need an interpreter to be read we need `yq`
Furthermore, this script also checks if you got your AWS CLI command interface and Serverless Framework CLI

**You should always check your credentials before use to avoid errors during deployment.**
## Usage

Just paste the bash script into your project root folder and execute
`bash dep.sh`
The script will check dependencies and advice you to install at least `yq` for the first time.
You can install it from here: https://mikefarah.github.io/yq/

Then follow the instructions to deploy a normal function (The ones inside `function:` at your *yml file. And the worker functions that will be inside your constructor.

There are options in case you type a wrong function to avoid unwanted deployments or in case you pass a function id not listed in the functions list.

## Notes
This has been tested on a MacBook Pro M1.
This is what I meant by workers Functions, when you need to create an SQS and assign a function to be triggered, you can do the following:

<img width="426" alt="SQS Constructor" src="https://user-images.githubusercontent.com/46604653/174325057-2cb7d9f6-7c4b-4857-ad05-0270c2792c62.png">

So whatever you name your SQS constructor, the worker function for that SQS will be called like: `[constructorSQSName]Worker` in this example the function for that SQS will be `sign-at-dec-queueWorker`

The Script can read that and concatenate those functions to the function list (This is not at DEMO Gif)

<img width="235" alt="WorkerListed" src="https://user-images.githubusercontent.com/46604653/174325918-269b2817-0940-4cef-8b4e-330013f6b8d3.png">


## Contribution
Stars, Beer, Coffee <3
