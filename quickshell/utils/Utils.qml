import QtQuick
import Quickshell
import "../services"
pragma Singleton

QtObject {
    function limitStr(str, maxLength) {
        if (str.length < maxLength)
            return str;

        return str.slice(0, maxLength - 3) + "...";
    }

    function levenshtein(a, b) {
        if (a.length < b.length)
            [a, b] = [b, a];

        if (b.length === 0)
            return a.length;

        let previousRow = Array.from({
            "length": b.length + 1
        }, (_, i) => {
            return i;
        });
        for (let i = 0; i < a.length; i++) {
            const c1 = a[i];
            const currentRow = [i + 1];
            for (let j = 0; j < b.length; j++) {
                const c2 = b[j];
                const insertions = previousRow[j + 1] + 1;
                const deletions = currentRow[j] + 1;
                const substitutions = previousRow[j] + (c1 !== c2 ? 1 : 0);
                currentRow.push(Math.min(insertions, deletions, substitutions));
            }
            previousRow = currentRow;
        }
        return previousRow[previousRow.length - 1] / a.length / b.length;
    }

    function score(app, query){
        const prefixBonus = app.name.toLowerCase().startsWith(query.toLowerCase()) ? 100000 : 0;
        let lDist = Utils.levenshtein(app.name.toLowerCase(),query.toLowerCase()); 
        let usage = AppUsage.usage?.[app.name] ?? 0
        return 20 / (lDist+1) + Math.log(usage+1)*0.5 + prefixBonus
    }

    function run(app){
        var u = AppUsage.usage || {}
        u[app.name] = (u[app.name] ?? 0) + 1
        AppUsage.usage = u

        if(app.runInTerminal)
            Quickshell.execDetached({
                command: ["kitty", "-e", "bash", "-c", app.command],
                workingDirectory: app.workingDirectory,
            });
        else
            app.execute();
    }

}
