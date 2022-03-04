#! -*- coding:utf-8 -*-
import requests
import json
import sys
from subtitle.subtitle_downloader import SubtitleDownloader

RPC = "http://localhost:%s/jsonrpc"
CONFIG = "/etc/aria2/aria2.conf"


def load_cfg(config_path: str, key: str):
    val = None
    with open(config_path, "r") as f:
        lines = f.readlines()
    for line in lines:
        if line.startswith(key):
            val = line[len(key):].strip()
            break
    return val

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
    token = "token:" + load_cfg(CONFIG, "rpc-secret=") or ""
    rpc_addr = RPC % (load_cfg(CONFIG, "rpc-listen-port=") or "6800")
    files = load_file_list(sys.argv[1], rpc_addr, token)
    download_subtitles(files)

