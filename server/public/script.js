async function insertCarnet() {
    const data = {
        temp_min: parseFloat(document.getElementById("tempMin").value) || null,
        temp_max: parseFloat(document.getElementById("tempMax").value) || null,
        hum_min: parseFloat(document.getElementById("humMin").value) || null,
        hum_max: parseFloat(document.getElementById("humMax").value) || null,
        prec_tot: parseFloat(document.getElementById("precTot").value) || null,
        prec_nat: document.getElementById("precNat").value || null,
        vent_min: parseFloat(document.getElementById("ventMin").value) || null,
        vent_max: parseFloat(document.getElementById("ventMax").value) || null,
        pres_min: parseFloat(document.getElementById("presMin").value) || null,
        pres_max: parseFloat(document.getElementById("presMax").value) || null,
        date: document.getElementById("carnetDate").value || null,
        note: document.getElementById("note").value || null,
    };

    const res = await fetch(`api/carnetMeteo`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
    });

    if (res.ok) alert("CarnetMeteo entry inserted!");
    else alert("Failed to insert entry");
}