import boto3
import json
from boto3.dynamodb.conditions import Key

def handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('dynamodb-all-messages')

    last_evaluated_key = event['queryStringParameters'].get('lastKey') if event['queryStringParameters'] else None
    last_evaluated_key = json.loads(last_evaluated_key) if last_evaluated_key else None

    try:
        query_params = {
            'KeyConditionExpression': Key('channel_id').eq('cyclone'),
            'ScanIndexForward': False,  # Tri par ordre décroissant selon la clé de tri
            'Limit': 10
        }

        if last_evaluated_key:
            query_params['ExclusiveStartKey'] = last_evaluated_key

        response = table.query(**query_params)

        messages = response.get('Items', [])
        last_evaluated_key = response.get('LastEvaluatedKey')

        return {
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': 'https://d1mhyz71pk3h10.cloudfront.net',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'statusCode': 200,
            'body': json.dumps({
                'messages': messages,
                'lastEvaluatedKey': last_evaluated_key
            })
        }

    except Exception as e:
        return {'statusCode': 500, 'body': str(e)}
