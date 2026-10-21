import glob
import json
import os
from pathlib import Path

import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import (
    any_xpath,
    check_for_hash,
    extract_fulltext_with_spacing,
    get_xmlid,
)

name_of_script = Path(__file__).name

print("#########")
print(f"running **{name_of_script}**")
print("first: collect the mentiones")

files = sorted(glob.glob("data/editions/*.xml"))

data = {}

for x in files:
    doc = TeiReader(x)
    root = doc.any_xpath("//tei:TEI")[0]
    root.attrib.pop("{http://www.w3.org/XML/1998/namespace}base", None)
    witt_list = {}
    file_id = os.path.split(x)[-1]
    for y in doc.any_xpath(".//tei:listWit[@xml:id='witnesses']/tei:witness"):
        xml_id = get_xmlid(y)

        witt_list[xml_id] = {
            "xml_id": xml_id,
            "ms": {
                "id": any_xpath(y, "./tei:ref/@target")[0].split("#")[-1],
                "label": extract_fulltext_with_spacing(any_xpath(y, "./tei:ref")[0]),
            },
        }
    for i, y in enumerate(
        doc.any_xpath(".//tei:seg[@type='formula' and @ana]"), start=1
    ):
        form_id = y.attrib["ana"].split("#")[-1]
        quote = extract_fulltext_with_spacing(y)
        folio_xml_id = any_xpath(y, "ancestor::tei:ab[@type='transcription']/@xml:id")[
            0
        ]
        seg_id = f"{folio_xml_id}-seg-{i:0>3}"
        y.attrib["{http://www.w3.org/XML/1998/namespace}id"] = seg_id
        wittness_id = check_for_hash(
            any_xpath(y, "ancestor::tei:div[@type='witness']/@corresp")[0]
        )
        formular_data = {
            "wittness_id": wittness_id,
            "folio_xml_id": folio_xml_id,
            "seg_id": seg_id,
            "quote": quote,
            "md": witt_list[wittness_id],
            "file_id": file_id,
        }
        try:
            data[form_id].append(formular_data)
        except KeyError:
            data[form_id] = [formular_data]
    ET.indent(doc.any_xpath(".")[0], space="   ")
    doc.tree_to_file(x)
with open("foo.json", "w", encoding="utf-8") as fp:
    json.dump(data, fp, ensure_ascii=False, indent=4)

print("second: write the mentiones into listformular.xml")

index_file = "data/indices/listformula.xml"
doc = TeiReader(index_file)

for bad in doc.any_xpath(".//tei:catDesc[@corresp]"):
    bad.getparent().remove(bad)

for x in doc.any_xpath(".//tei:category[@xml:id]"):
    cat_xml_id = get_xmlid(x)
    try:
        mentions = data[cat_xml_id]
        for y in mentions:
            cat_desc = ET.SubElement(x, "{http://www.tei-c.org/ns/1.0}catDesc")
            cat_desc.attrib["corresp"] = f"{y['file_id']}#{y['folio_xml_id']}"
            cat_ref = ET.SubElement(cat_desc, "{http://www.tei-c.org/ns/1.0}ref")
            cat_ref.attrib["target"] = f"{y['file_id']}#{y['md']['xml_id']}"
            cat_ref.text = y["md"]["ms"]["label"]
            cat_q = ET.SubElement(cat_desc, "{http://www.tei-c.org/ns/1.0}q")
            cat_q.attrib["corresp"] = f"{y['file_id']}#{y['seg_id']}"
            cat_q.text = y["quote"]
    except KeyError:
        continue
ET.indent(doc.any_xpath(".")[0], space="   ")
doc.tree_to_file(index_file)
