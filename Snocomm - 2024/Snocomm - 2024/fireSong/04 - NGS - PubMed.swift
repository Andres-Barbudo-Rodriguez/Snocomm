//
//  04 - NGS - PubMed.swift
//  Snocomm - 2024
//
//  Created by Andres Barbudo on 7/30/24.
//  Copyright © 2024 Andres Barbudo. All rights reserved.
//

import Foundation
import BioSwift


let refs = rec.annotations["references"] as! [BioSwift.Reference]

for ref in refs {
    if let pubmedID = ref.pubmedID, !pubmedID.isEmpty {
        print(pubmedID)
        

        let handle = BioSwift.Entrez.efetch(db: "pubmed", id: [pubmedID], rettype: "medline", retmode: "text")
        

        let records = BioSwift.Medline.parse(handle: handle)
        
        for medRec in records {
            for (k, v) in medRec.items {
                print("\(k): \(v)")
            }
        }
    }
}
