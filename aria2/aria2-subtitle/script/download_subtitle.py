#! -*- coding:utf-8 -*-
import requests
import json
import sys
from subtitle.subtitle_downloader import SubtitleDownloader

RPC = "http://localhost:6800/jsonrpc"
CONFIG = "/etc/aria2/aria2.conf"


def load_token(config_path: str):
    token = None
    with open(config_path, "r") as f:
        lines = f.readlines()
    for line in lines:
        if line.startswith("rpc-secret="):
            token = "token:" + line[len("rpc-secret="):].strip()
            break
    return token


def load_file_list(gid: str, rpc: str, token):
    params = [token, gid] if token else [gid]
    data = json.dumps({
        'jsonrpc': '2.0',
        'method': 'aria2.tellStatus',
        "id": "qwer",
        'params': params,
    })
    res = requests.post(rpc, data).json()
    file_list = [f['path'] for f in res['result']['files']]
    return file_list


def download_subtitles(file_list: list):
    for f in file_list:
        try:
            SubtitleDownloader.download_subtitle(f)
        except:
            pass


if __name__ == "__main__":
    token = load_token(CONFIG)
    files = load_file_list(sys.argv[1], RPC, token)
    download_subtitles(files)

