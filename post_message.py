import boto3
import json
from datetime import datetime


def handler(event, context):
    try:
        body = json.loads(event['body'])
    except:
        return {'statusCode': 400, 'body': 'Corps de la requête invalide ou manquant'}

    if 'message' not in body:
        return {'statusCode': 400, 'body': 'Message manquant'}

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('dynamodb-all-messages')

    try:
        response = table.put_item(
            Item={
                'channel_id': 'cyclone',
                'timestamp_utc_iso8601': datetime.utcnow().isoformat(),
                'message': body['message'],
                'user': event['requestContext']['authorizer']['claims']['cognito:username']
            }
        )
        return {
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': 'https://d1mhyz71pk3h10.cloudfront.net',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'statusCode': 200, 'body': json.dumps(response)}
    except Exception as e:
        return {'statusCode': 500, 'body': str(e)}
