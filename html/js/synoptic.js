async function populateWitnessSelect() {
    const selectElement = document.getElementById("witness-select");
    selectElement.multiple = true;
    selectElement.size = 10;

    try {
        const response = await fetch("data/col-select-data.json");

        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }

        const data = await response.json();

        // Group entries by title
        const groups = new Map();

        data.forEach(item => {
            if (!groups.has(item.title)) {
                groups.set(item.title, []);
            }
            groups.get(item.title).push(item);
        });

        // Clear select
        selectElement.replaceChildren();

        // Add placeholder
        selectElement.add(new Option("Please select ...", ""));

        // Create optgroups and options
        groups.forEach((items, title) => {
            const optgroup = document.createElement("optgroup");
            optgroup.label = title;

            items.forEach(item => {
                // Transcript
                const transcript = new Option(
                    `${item.ms} — Transcript`,
                    item.transcript_id
                );
                transcript.dataset.htmlFile = item.html_file;
                transcript.dataset.type = "transcript";

                // Translation
                const translation = new Option(
                    `${item.ms} — Translation`,
                    item.translation_id
                );
                translation.dataset.htmlFile = item.html_file;
                translation.dataset.type = "translation";

                optgroup.appendChild(transcript);
                optgroup.appendChild(translation);
            });

            selectElement.appendChild(optgroup);
        });

    } catch (error) {
        console.error("Could not load manuscript data:", error);
        selectElement.replaceChildren(
            new Option("Error loading manuscripts", "")
        );
    }
}

populateWitnessSelect();