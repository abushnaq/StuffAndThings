//
//  PhotoProvider.swift
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 1/11/16.
//  Copyright © 2016 Ahmad Bushnaq. All rights reserved.
//

import Foundation
import UIKit

@objc
public class PhotoProvider : NSObject
{
    var currentPhotoSet : NSArray
    var challengeID : Int
    var currentPhotoIndex : Int
    var totalPointBounty : Int
    
    override init()
    {
        self.currentPhotoIndex = 0
        self.currentPhotoSet = NSArray()
        self.challengeID = 0
        self.totalPointBounty = 0
        
    }
    
    func nextImage() -> UIImage
    {
        return UIImage(named: "Hôtel_de_Sully_depuis_la_rue_de_l'Hôtel-Saint-Paul,_Paris_1981")!
    }
    
//    - (UIImage*) nextImage
//    {
//    return [UIImage imageNamed:@"Hôtel_de_Sully_depuis_la_rue_de_l'Hôtel-Saint-Paul,_Paris_1981"];
//    }
    
}

