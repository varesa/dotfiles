#!/usr/bin/python3

# https://raw.githubusercontent.com/JordanL2/LinuxSetup/67506cc825ea79bea505b36d9d8abe3467abae2b/Sway/config/sway/swayipc.py

import asyncio
import os
import json
import sys


socket = os.environ['SWAYSOCK']

magic_string = 'i3-ipc'
magic_string_len = len(magic_string)
payload_length_length = 4
payload_type_length = 4

message_types = {
	'RUN_COMMAND': 0,
	'GET_WORKSPACES': 1,
	'SUBSCRIBE': 2,
	'GET_OUTPUTS': 3,
	'GET_TREE': 4,
	'GET_MARKS': 5,
	'GET_BAR_CONFIG': 6,
	'GET_VERSION': 7,
	'GET_BINDING_MODES': 8,
	'GET_CONFIG': 9,
	'SEND_TICK': 10,
	'SYNC': 11,
	'GET_INPUTS': 100,
	'GET_SEATS': 101,
}


class SwayIPCConnection():

	async def new(message_type, command=''):
		self = SwayIPCConnection()

		payload_length = len(command)
		payload_type = message_types[message_type.upper()]

		data = magic_string.encode()
		data += payload_length.to_bytes(payload_length_length, sys.byteorder)
		data += payload_type.to_bytes(payload_type_length, sys.byteorder)
		data += command.encode()

		(reader, writer) = await asyncio.open_unix_connection(path=socket)
		writer.write(data)
		await writer.drain()

		self.reader = reader
		self.writer = writer

		return self

	async def receive(self):
		header = await self.reader.read(magic_string_len + payload_length_length + payload_type_length)
		payload_length_bytes = header[magic_string_len : magic_string_len + payload_length_length]
		payload_length = int.from_bytes(payload_length_bytes, sys.byteorder)
		response = await self.reader.read(payload_length)
		return (response).decode()

	async def receive_json(self):
		response = await self.receive()
		return json.loads(response)

	async def close(self):
		if not self.writer.is_closing():
			self.writer.close()
			await self.writer.wait_closed()


async def send_receive(message_type, command=''):
	connection = await SwayIPCConnection.new(message_type, command)
	response = await connection.receive()
	await connection.close()
	return response

async def send_receive_json(message_type, command=''):
	response = await send_receive(message_type, command)
	return json.loads(response)


async def run_command(command):
	return await send_receive_json('RUN_COMMAND', command)

async def get_workspaces():
	return await send_receive_json('GET_WORKSPACES')

async def subscribe(events):
	return await SwayIPCConnection.new('SUBSCRIBE', json.dumps(events))

async def get_outputs():
	return sorted(await send_receive_json('GET_OUTPUTS'), key = lambda o : o['rect']['x'])

async def get_tree():
	return await send_receive_json('GET_TREE')
