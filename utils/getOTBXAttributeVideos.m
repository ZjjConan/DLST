function seqNames = getOTBXAttributeVideos(attribute)
    % attribute
    % IV: Illumination Variation - the illumination in the target region is 
    %     significantly changed.
    % SV: Scale Variation 每 the ratio of the bounding boxes of the first 
    %     frame and the current frame is out of the range ts, ts > 1 (ts=2).
    % OCC: Occlusion 每 the target is partially or fully occluded.
    % DEF: Deformation 每 non-rigid object deformation.
    % MB: Motion Blur 每 the target region is blurred due to the motion of 
    %     target or camera.
    % FM: Fast Motion 每 the motion of the ground truth is larger than tm 
    %     pixels (tm=20).
    % IPR: In-Plane Rotation 每 the target rotates in the image plane.
    % OPR: Out-of-Plane Rotation 每 the target rotates out of the image 
    %      plane.
    % OV: Out-of-View 每 some portion of the target leaves the view.
    % BC: Background Clutters 每 the background near the target has the 
    %     similar color or texture as the target.
    % LR: Low Resolution 每 the number of pixels inside the ground-truth 
    %     bounding box is less than tr (tr =400).

    switch(upper(attribute))
        case {'IV'}
            seqNames = {'Basketball'; 'Box'; 'Car1'; 'Car2'; 'Car24'; 'Car4'; 'CarDark'; 'Coke'; 
                        'Crowds'; 'David'; 'Doll'; 'FaceOcc2'; 'Fish'; 'Human2'; 'Human4';
                        'Human7'; 'Human8'; 'Human9'; 'Ironman'; 'KiteSurf'; 'Lemming'; 'Liquor'; 
                        'Man'; 'Matrix'; 'Mhyang'; 'MotorRolling'; 'Shaking'; 'Singer1'; 'Singer2';
                        'Skating1'; 'Skiing'; 'Soccer'; 'Sylvester'; 'Tiger1'; 'Tiger2'; 'Trans'; 
                        'Trellis'; 'Woman'};
        case {'SV'}
            seqNames = {'Biker'; 'BlurBody'; 'BlurCar2'; 'BlurOwl'; 'Board'; 'Box'; 'Boy'; 'Car1'; 
                        'Car24'; 'Car4'; 'CarScale'; 'ClifBar'; 'Couple'; 'Crossing'; 'Dancer'; 'David';
                        'Diving'; 'Dog'; 'Dog1'; 'Doll'; 'DragonBaby'; 'Dudek'; 'FleetFace'; 'Freeman1';
                        'Freeman3'; 'Freeman4'; 'Girl'; 'Girl2'; 'Gym'; 'Human2'; 'Human3'; 'Human4';
                        'Human5'; 'Human6'; 'Human7'; 'Human8'; 'Human9'; 'Ironman'; 'Jump'; 'Lemming'; 
                        'Liquor'; 'Matrix'; 'MotorRolling'; 'Panda'; 'RedTeam'; 'Rubik'; 'Shaking';
                        'Singer1'; 'Skater'; 'Skater2'; 'Skating1'; 'Skating2-1'; 'Skating2-2'; 'Skiing'; 
                        'Soccer'; 'Surfer'; 'Toy'; 'Trans'; 'Trellis'; 'Twinnings'; 'Vase'; 'Walking'; 
                        'Walking2'; 'Woman'};
        case {'OCC'}
            seqNames = {'Basketball'; 'Biker'; 'Bird2'; 'Bolt'; 'Box'; 'CarScale'; 'ClifBar'; 'Coke';
                        'Coupon'; 'David'; 'David3'; 'Doll'; 'DragonBaby'; 'Dudek'; 'FaceOcc1'; 'FaceOcc2';
                        'Football'; 'Freeman4'; 'Girl'; 'Girl2'; 'Human3'; 'Human4'; 'Human5'; 'Human6';
                        'Human7'; 'Ironman'; 'Jogging-1'; 'Jogging-2'; 'Jump'; 'KiteSurf'; 'Lemming';
                        'Liquor'; 'Matrix'; 'Panda'; 'RedTeam'; 'Rubik'; 'Singer1'; 'Skating1'; 'Skating2-1';
                        'Skating2-2'; 'Soccer'; 'Subway'; 'Suv'; 'Tiger1'; 'Tiger2'; 'Trans'; 'Walking';
                        'Walking2'; 'Woman'};
        case {'DEF'}
            seqNames = {'Basketball'; 'Bird1'; 'Bird2'; 'BlurBody'; 'Bolt'; 'Bolt2'; 'Couple'; 'Crossing';
                        'Crowds'; 'Dancer'; 'Dancer2'; 'David'; 'David3'; 'Diving'; 'Dog'; 'Dudek'; 'FleetFace';
                        'Girl2'; 'Gym'; 'Human3'; 'Human4'; 'Human5'; 'Human6'; 'Human7'; 'Human8'; 'Human9';
                        'Jogging-1'; 'Jogging-2'; 'Jump'; 'Mhyang'; 'Panda'; 'Singer2'; 'Skater'; 'Skater2';
                        'Skating1'; 'Skating2-1'; 'Skating2-2'; 'Skiing'; 'Subway'; 'Tiger1'; 'Tiger2';
                        'Trans'; 'Walking'; 'Woman'};
        case {'MB'}
            seqNames = {'Biker'; 'BlurBody'; 'BlurCar1'; 'BlurCar2'; 'BlurCar3'; 'BlurCar4'; 'BlurFace';
                        'BlurOwl'; 'Board'; 'Box'; 'Boy'; 'ClifBar'; 'David'; 'Deer'; 'DragonBaby';
                        'FleetFace'; 'Girl2'; 'Human2'; 'Human7'; 'Human9'; 'Ironman'; 'Jump'; 'Jumping';
                        'Liquor'; 'MotorRolling'; 'Soccer'; 'Tiger1'; 'Tiger2'; 'Woman'};
        case {'FM'}
            seqNames = {'Biker'; 'Bird1'; 'Bird2'; 'BlurBody'; 'BlurCar1'; 'BlurCar2'; 'BlurCar3'; 'BlurCar4';
                        'BlurFace'; 'BlurOwl'; 'Board'; 'Boy'; 'CarScale'; 'ClifBar'; 'Coke'; 'Couple'; 'Deer';
                        'DragonBaby'; 'Dudek'; 'FleetFace'; 'Human6'; 'Human7'; 'Human9'; 'Ironman'; 'Jumping';
                        'Lemming'; 'Liquor'; 'Matrix'; 'MotorRolling'; 'Skater2'; 'Skating2-1'; 'Skating2-2';
                        'Soccer'; 'Surfer'; 'Tiger1'; 'Tiger2'; 'Toy'; 'Vase'; 'Woman'};
        case {'IPR'}
            seqNames = {'Bird2'; 'BlurBody'; 'BlurFace'; 'BlurOwl'; 'Bolt'; 'Box'; 'Boy'; 'CarScale'; 'ClifBar';
                        'Coke'; 'Dancer'; 'David'; 'David2'; 'Deer'; 'Diving'; 'Dog1'; 'Doll'; 'DragonBaby';
                        'Dudek'; 'FaceOcc2'; 'FleetFace'; 'Football'; 'Football1'; 'Freeman1'; 'Freeman3';
                        'Freeman4'; 'Girl'; 'Gym'; 'Ironman'; 'Jump'; 'KiteSurf'; 'Matrix'; 'MotorRolling';
                        'MountainBike'; 'Panda'; 'RedTeam'; 'Rubik'; 'Shaking'; 'Singer2'; 'Skater'; 'Skater2';
                        'Skiing'; 'Soccer'; 'Surfer'; 'Suv'; 'Sylvester'; 'Tiger1'; 'Tiger2'; 'Toy';
                        'Trellis'; 'Vase'};
        case {'OPR'}
            seqNames = {'Basketball'; 'Biker'; 'Bird2'; 'Board'; 'Bolt'; 'Box'; 'Boy'; 'CarScale'; 'Coke';
                        'Couple'; 'Dancer'; 'David'; 'David2'; 'David3'; 'Dog'; 'Dog1'; 'Doll'; 'DragonBaby';
                        'Dudek'; 'FaceOcc2'; 'FleetFace'; 'Football'; 'Football1'; 'Freeman1'; 'Freeman3';
                        'Freeman4'; 'Girl'; 'Girl2'; 'Gym'; 'Human2'; 'Human3'; 'Human6'; 'Ironman'; 'Jogging-1';
                        'Jogging-2'; 'Jump'; 'KiteSurf'; 'Lemming'; 'Liquor'; 'Matrix'; 'Mhyang'; 'MountainBike';
                        'Panda'; 'RedTeam'; 'Rubik'; 'Shaking'; 'Singer1'; 'Singer2'; 'Skater'; 'Skater2';
                        'Skating1'; 'Skating2-1'; 'Skating2-2'; 'Skiing'; 'Soccer'; 'Surfer'; 'Sylvester';
                        'Tiger1'; 'Tiger2'; 'Toy'; 'Trellis'; 'Twinnings'; 'Woman'};
        case {'OV'}
            seqNames = {'Biker'; 'Bird1'; 'Board'; 'Box'; 'ClifBar'; 'DragonBaby'; 'Dudek'; 'Human6';
                        'Ironman'; 'Lemming'; 'Liquor'; 'Panda'; 'Suv'; 'Tiger2'};
        case {'BC'}
            seqNames = {'Basketball'; 'Board'; 'Bolt2'; 'Box'; 'Car1'; 'Car2'; 'Car24'; 'CarDark'; 'ClifBar';
                        'Couple'; 'Coupon'; 'Crossing'; 'Crowds'; 'David3'; 'Deer'; 'Dudek'; 'Football';
                        'Football1'; 'Human3'; 'Ironman'; 'Liquor'; 'Matrix'; 'Mhyang'; 'MotorRolling';
                        'MountainBike'; 'Shaking'; 'Singer2'; 'Skating1'; 'Soccer'; 'Subway'; 'Trellis'};
        case {'LR'}
            seqNames = {'Biker'; 'Car1'; 'Freeman3'; 'Freeman4'; 'Panda'; 'RedTeam'; 'Skiing'; 'Surfer'; 'Walking'};
        otherwise
            error('not support attritube');
    end

end

