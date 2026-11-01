import glob
import json
import os
from pathlib import Path

from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import any_xpath, get_xmlid

json_data_dir = os.path.join("html", "data")
jsond_data_file = os.path.join(json_data_dir, "col-select-data.json")
os.makedirs(json_data_dir, exist_ok=True)

name_of_script = Path(__file__).name

print("#########")
print(f"running **{name_of_script}**")

files = glob.glob("./data/editions/*.xml")
data = []
for x in files:
    html_file = os.path.split(x)[-1].replace(".xml", ".html")
    item = {}
    doc = TeiReader(x)
    title = doc.any_xpath(".//tei:title")[0].text
    for y in doc.any_xpath(".//tei:witness[@xml:id]"):
        wit_id = get_xmlid(y).replace("-md", "")

        item = {"id": wit_id}
        item["ms"] = any_xpath(y, "./tei:ref")[0].text
        item["title"] = title
        item["html_file"] = html_file
        item["transcript_id"] = f"html-transcript-{wit_id}"
        item["translation_id"] = f"html-translation-{wit_id}"

        data.append(item)

with open(jsond_data_file, "w", encoding="utf-8") as fp:
    json.dump(data, fp, ensure_ascii=False, indent=4)
print("#########")
