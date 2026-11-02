async function populateWitnessSelection() {
    const container = document.getElementById("witness-selection");

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

        container.replaceChildren();

        let index = 0;

        groups.forEach((items, title) => {
            const group = document.createElement("details");
            group.className = "mb-3 border rounded p-2";

            const legend = document.createElement("summary");
            legend.className = "fs-6 fw-semibold";
            legend.append(title + " ");

            const count = document.createElement("span");
            count.className = "badge text-bg-secondary ms-1";
            count.textContent = items.length;
            count.title = `${items.length} witness${items.length === 1 ? "" : "es"}`;
            legend.appendChild(count);

            group.appendChild(legend);

            items.forEach(item => {
                const manuscript = document.createElement("div");
                manuscript.className = "mb-3";

                const heading = document.createElement("div");
                heading.className = "small fw-semibold mb-2";
                heading.textContent = item.ms;

                manuscript.appendChild(heading);

                const buttonGroup = document.createElement("div");
                buttonGroup.className = "d-flex gap-2";

                ["transcript", "translation"].forEach(type => {
                    const id = `witness-option-${index++}`;
                    const value = type === "transcript"
                        ? item.transcript_id
                        : item.translation_id;

                    const input = document.createElement("input");
                    input.type = "checkbox";
                    input.className = "btn-check";
                    input.id = id;
                    input.value = value;
                    input.dataset.htmlFile = item.html_file;
                    input.dataset.type = type;
                    input.dataset.title = item.title;
                    input.dataset.ms = item.ms;

                    const label = document.createElement("label");
                    label.className = "btn btn-sm btn-outline-primary";
                    label.htmlFor = id;
                    label.textContent = type === "transcript"
                        ? "Transcript"
                        : "Translation";

                    buttonGroup.append(input, label);
                });

                manuscript.appendChild(buttonGroup);
                group.appendChild(manuscript);
            });

            container.appendChild(group);
        });

    } catch (error) {
        console.error("Could not load manuscript data:", error);
        container.textContent = "Error loading manuscript data.";
    }
}

const container = document.getElementById("witness-selection");
const viewContainer = document.getElementById("view-container");

function updateUrl() {
    const ids = Array.from(container.querySelectorAll("input:checked"))
        .map(input => input.value);
    const url = new URL(window.location.href);
    if (ids.length) {
        url.searchParams.set("sel", ids.join(","));
    } else {
        url.searchParams.delete("sel");
    }
    history.replaceState(null, "", url);
}

function restoreFromUrl() {
    const sel = new URLSearchParams(window.location.search).get("sel");
    if (!sel) return;
    const ids = new Set(sel.split(",").filter(Boolean));
    container.querySelectorAll("input[type=checkbox]").forEach(input => {
        input.checked = ids.has(input.value);
        if (input.checked) input.closest("details").open = true;
    });
}

container.addEventListener("change", event => {
    // The label stays hovered after a click, so clear its highlight explicitly
    if (!event.target.checked) setHighlight(event.target.value, false);
    updateUrl();
    renderSelection();
});

populateWitnessSelection().then(() => {
    restoreFromUrl();
    renderSelection();
});

// Highlight a button and its panel together while hovering either one
function setHighlight(id, on) {
    const input = Array.from(container.querySelectorAll("input"))
        .find(el => el.value === id);
    const panel = Array.from(viewContainer.querySelectorAll("[data-witness-id]"))
        .find(el => el.dataset.witnessId === id);
    if (input && input.nextElementSibling) {
        input.nextElementSibling.classList.toggle("shadow", on);
        input.nextElementSibling.classList.toggle("border-warning", on);
        input.nextElementSibling.classList.toggle("border-3", on);
    }
    if (panel) {
        panel.classList.toggle("border-warning", on);
        panel.classList.toggle("border-3", on);
        panel.classList.toggle("shadow", on);
    }
}

function hoverTargetId(event) {
    const label = event.target.closest("label");
    if (label && container.contains(label)) {
        const input = label.previousElementSibling;
        return input && input.checked ? input.value : null;
    }
    const panel = event.target.closest("[data-witness-id]");
    return panel && viewContainer.contains(panel) ? panel.dataset.witnessId : null;
}

[container, viewContainer].forEach(root => {
    root.addEventListener("mouseover", event => {
        const id = hoverTargetId(event);
        if (id) setHighlight(id, true);
    });
    root.addEventListener("mouseout", event => {
        const id = hoverTargetId(event);
        if (id) setHighlight(id, false);
    });
});

async function renderSelection() {
    const selected = Array.from(
        container.querySelectorAll("input:checked")
    ).map(input => ({
        id: input.value,
        htmlFile: input.dataset.htmlFile,
        type: input.dataset.type,
        title: input.dataset.title,
        ms: input.dataset.ms
    }));

    viewContainer.replaceChildren();

    for (const item of selected) {
        const response = await fetch(item.htmlFile);

        if (!response.ok) {
            console.error(`Could not load ${item.htmlFile}`);
            continue;
        }

        const html = await response.text();
        const doc = new DOMParser().parseFromString(html, "text/html");

        const content = doc.getElementById(item.id);

        if (!content) continue;

        // Create column
        const column = document.createElement("div");
        column.className = "col-12 col-md-6 col-xl-4";

        // Create panel
        const panel = document.createElement("div");
        panel.className = "border rounded p-3 h-100";
        panel.dataset.witnessId = item.id;

        // Add heading
        const heading = document.createElement("h2");
        heading.className = "fs-6 fw-semibold border-bottom pb-2 mb-3";
        heading.textContent = `${item.ms} – ${item.type === "transcript" ? "Transcript" : "Translation"}`;

        panel.appendChild(heading);
        panel.appendChild(content.cloneNode(true));

        column.appendChild(panel);
        viewContainer.appendChild(column);
    }
}