//
//  03 - NGS - NCBI.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/30/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import BioSwift


BioSwift.Entrez.email = "postlock"


let searchTerm = "CRT[Gene Name] AND \"Plasmodium falciparum\"[Organism]"
var recList = BioSwift.Entrez.esearch(db: "nucleotide", term: searchTerm)


if recList.retMax < recList.count {
    recList = BioSwift.Entrez.esearch(db: "nucleotide", term: searchTerm, retmax: recList.count)
}


let idList = recList.idList
let hdl = BioSwift.Entrez.efetch(db: "nucleotide", id: idList, rettype: "gb")
let recs = BioSwift.SeqIO.parse(handle: hdl, format: "gb")

var targetRec: BioSwift.Sequence?


for rec in recs {
    if rec.name == "KM28867" {
        targetRec = rec
        break
    }
}


if let rec = targetRec {
    print(rec.name)
    print(rec.description)
    
    for feature in rec.features {
        switch feature.type {
        case "gene":
            if let geneName = feature.qualifiers["gene"] {
                print(geneName)
            }
        case "exon":
            let loc = feature.location
            print("\(loc.start), \(loc.end), \(loc.strand)")
        default:
            print("not processed:\n\(feature)")
        }
    }
    
    for (name, value) in rec.annotations {
        print("\(name)=\(value)")
    }
    
    print(rec.seq.count)
} else {
    print("Record not found")
}
