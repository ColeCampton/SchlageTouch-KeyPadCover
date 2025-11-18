//////////////////////////////////////////////////
// Filament Hinge Box v1.0
// by SteveS42 @ Printables.com
// Create a filament hinge box with dimensions
// driven by user defined cell size and count.
//////////////////////////////////////////////////
// Changing the following variable values manually
// is not recommended. Please use the Customizer.
// On Window menu, select Customizer - or -
// On Window menu, uncheck Hide Customizer,
// Then click the section triangles to open each.
//////////////////////////////////////////////////

/* [Cells] */
// Cell inside dimension on X axis.
cellInsideX = 140; // [1:0.1:100]
// Number of cells on X axis.
cellCountX = 1; // [1:1:12]
// Cell inside dimension on Y axis.
cellInsideY = 78; // [1:0.1:100]
// Number of cells on Y axis.
cellCountY = 1; // [1:1:12]
// Thickness of inside walls.
cellWallThickness = .6; // [0.6:0.1:2]
// Height of inside walls of lid.
lidCellWallHeight = 38.1; // [0:0.1:50]
// Height of inside walls of base.
baseCellWallHeight = 38.1; // [0:0.1:50]

/* [Box] */
// Height of lid (inside).
lidInsideZ = 10; // [0:0.1:50]
// Thickness of lid (outside).
lidThickness = 1.6; // [1:0.1:2]
// Height of base (inside).
baseInsideZ = 30; // [4:0.1:50]
// Thickness of outside walls. Bottom, & sides.
outsideWallThickness = 3.5; // [1:0.1:2]

/* [Hinge] */
// Hinge clearance (between parts).
hingeClearance = .2; // [0.1:0.1:0.5]
// Diameter of filament hole.
filamentDiameter = 2; // [1.8:0.1:4]
// Filament to hole clearance.
filamentClearance = .1; // [0:0.05:0.2]
magnetHoleDiam = 2.1;
magnetHoleHeight = 2.1;

/* [Wall Mount] */
plateThick = 2.1;
plateWidth = 15;
holeDiam = 6.5;

/* [Display] */
// To create STL of base, UNCHECK other parts
showBase = true;
// To create STL of lid, UNCHECK other parts
showLid = false;
// To create STL of latch, UNCHECK other parts
showLatch = false;
// Rotate lid to check fit.
lidRotate = 0; // [0:1:180]
// Rotate latch to check fit.
latchRotate = 0; // [0:1:90]
// Add printing support for latch rods.
addSupport = false;
// Show the parts in individual colors.
showColor = true;
// Display the insides to study clearances.
showCutout = false;

//////////////////////////////////////////////////
// Beyond here, there be dragons...
//////////////////////////////////////////////////
/* [Hidden] */
$fn = 100;
eps = .01; // extend past surface

// calculate outside dimensions
totalOutsideX = 
  (cellInsideX*cellCountX)
  +((cellCountX-1)*cellWallThickness)
  +outsideWallThickness*2;
totalOutsideY = 
  (cellInsideY*cellCountY)
  +((cellCountY-1)*cellWallThickness)
  +outsideWallThickness*2;
echo(str("totalOutsideX = ", 
          totalOutsideX));
echo(str("totalOutsideY = ", 
          totalOutsideY));
baseOutsideZ = 
  baseInsideZ+outsideWallThickness;
lidOutsideZ = lidInsideZ+lidThickness;

// calculate inside details
cellWallCutdownX = 
  (cellInsideX*cellCountX)
  +((cellCountX-1)*cellWallThickness);
echo(str("cellWallCutdownX = ", 
          cellWallCutdownX));
cellWallCutdownY = 
  (cellInsideY*cellCountY)
  +((cellCountY-1)*cellWallThickness);
baseCellWallCutdownZ = 
  baseInsideZ-baseCellWallHeight ;
echo(str("baseCellWallCutdownZ = ", 
          baseCellWallCutdownZ));
lidCellWallCutdownZ = 
  lidInsideZ-lidCellWallHeight ;
echo(str("lidCellWallCutdownZ = ", 
          lidCellWallCutdownZ));

// calculate hinge details
hingeSupportThickness = 2;
hingeSupportDiameter = 
  hingeSupportThickness*2
    +filamentDiameter;
hingeSupportRadius = hingeSupportDiameter/2;
hingeLength = totalOutsideY*2/10;
filamentRadius = filamentDiameter/2;
hingeOuterRadius = hingeSupportDiameter/2;
hingeInnerRadius = filamentRadius;
shift = // amount to shift from zero axis
  (hingeOuterRadius > lidOutsideZ) ?
    hingeOuterRadius-lidOutsideZ : 0;
echo(str("shift = ", 
          shift));

// latch details
// the latch
latchThickness = 1; // thickness
latchClearance = .4;
latchOptimalLength = 18; // latch ctr to ctr
latchHandle = 4; // handle extension
latchOptimalWidth = 18; // latch best width

latchEndWidth = 3; // support at rod ends
latchWidth = // latch actual width
  ((totalOutsideY
      -latchEndWidth*2
      -latchClearance*2)
    > latchOptimalWidth) ?
      latchOptimalWidth :
      (totalOutsideY
        -latchEndWidth*2
        -latchClearance*2); 
echo(str("latchWidth = ", 
          latchWidth));
// narrow latch warning
if (latchWidth < 2) {
    color(showColor?"red":undef){
    translate([0, -20, 0]) {
      rotate([45, 0, 0]) {
        text(text = (str(
          "latch too narrow")),
          size=4);
      }
    }
  }
}
// the rod
latchRodDiameter = 3;
latchRodRadius = latchRodDiameter/2;
latchRodLength = 
  latchWidth+latchClearance;
latchStandoff = 1.5; // rod to box separation
latchVertical = 
  latchRodDiameter+latchStandoff;

// print support
latchRodPrintSupportWidth = .6;
latchRodPrintSupportSeparation = .02;

latchOuterDiameter = 
  latchRodDiameter
    +latchClearance; // outside diameter
latchOuterRadius =
  ((latchOuterDiameter)
    +latchThickness*2)/2; // outside radius
latchInsideRadius = 
  (latchOuterDiameter)/2; // inside radius

// calculate the latch position
lidMax = 
  (lidInsideZ > 1) ?
    lidOutsideZ/2 : 1;
lidCenter = // center can't be bigger than max
  (lidOutsideZ/2 > lidMax) ?
    lidMax : (lidOutsideZ/2 > 1) ?
    lidOutsideZ/2 : 1;
lidOptimal = latchOptimalLength/2;
echo(str("lidMax = ", 
          lidMax));
echo(str("lidCenter = ", 
          lidCenter));
echo(str("lidOptimal = ", 
          lidOptimal));

baseMax = 
  baseOutsideZ-shift
  -latchRodRadius-latchThickness;
baseCenter = // center can't be bigger than max
  (baseOutsideZ/2 > baseMax) ? 
    baseMax : baseOutsideZ/2;
baseOptimal = latchOptimalLength/2;

echo(str("baseMax = ", 
          baseMax));
echo(str("baseCenter = ", 
          baseCenter));
echo(str("baseOptimal = ", 
          baseOptimal));

lidNeededWithBaseAtCenter = 
  latchOptimalLength-baseCenter;
lidNeededWithBaseAtMax = 
  latchOptimalLength-baseMax;
baseNeededWithLidAtCenter = 
  latchOptimalLength-lidCenter;
baseNeededWithLidAtMax = 
  latchOptimalLength-lidMax;
echo(str("lidNeededWithBaseAtCenter = ", 
          lidNeededWithBaseAtCenter));
echo(str("lidNeededWithBaseAtMax = ", 
          lidNeededWithBaseAtMax));
echo(str("baseNeededWithLidAtCenter = ", 
          baseNeededWithLidAtCenter));
echo(str("baseNeededWithLidAtMax = ", 
          baseNeededWithLidAtMax));

latchLidPosition = 
  // will both optimals fit?
  (lidOptimal<=lidMax && baseOptimal<=baseMax) ?
    // yes, set both optimal
    lidOptimal : 
    // no, continue...
    // is lid smaller?
    (lidMax<=baseMax) ? 
      // yes, will base fit remainder if lid centered?
      (baseNeededWithLidAtCenter<=baseMax) ?
        // yes, use lid centered
        lidCenter :
        // no, use lid max
        lidMax : 
    // else, base is smaller
      // will lid fit remainder if base centered?
      (lidNeededWithBaseAtCenter<=lidMax) ?
        // yes, use that remainder
        lidNeededWithBaseAtCenter :
        // no, will lid fit remainder if base max?
        (lidNeededWithBaseAtMax<=lidMax) ?
          // yes, use that remainder
          lidNeededWithBaseAtMax :
          // no, must use max
          lidMax;

latchBasePosition = 
  // will both optimals fit?
  (lidOptimal<=lidMax && baseOptimal<=baseMax) ?
    // yes, set both optimal
    baseOptimal : 
    // no, continue...
    // is lid smaller?
    (lidMax<=baseMax) ?
      // yes, will base fit remainder if lid centered?    
      (baseNeededWithLidAtCenter<=baseMax) ?
        // yes, use that remainder
        baseNeededWithLidAtCenter :
        // no, will lid fit remainder if base max?
        (baseNeededWithLidAtMax<=baseMax) ?
          // yes, use that remainder
          baseNeededWithLidAtMax :
          // no, use base max
          baseMax :
    // else, base is smaller
      // will base fit remainder if lid centered?
      (lidNeededWithBaseAtCenter<=lidMax) ?
        // yes, use center
        baseCenter :
        // no must use max
        baseMax;

latchLength = latchLidPosition
                +latchBasePosition;

echo(str("latchLidPosition = ", 
          latchLidPosition));
echo(str("latchBasePosition = ", 
          latchBasePosition));
echo(str("latchLength = ", 
          latchLength));

// short latch warning
if (latchLength < 6) {
    color(showColor?"red":undef){
    translate([0, -40, 0]) {
      rotate([45, 0, 0]) {
        text(text = (str(
          "latch may be too short")),
          size=4);
      }
    }
  }
}
//////////////////////////////////////////////////


//////////////////////////////////////////////////
// Main routines

// Make the box
difference(){
  union(){
    // make base
    if (showBase) {
      translate([0, 0, 0]) {
        rotate([0, 0, 0]) {
          baseHinge();
          base();
//          latchAttach(
//            +hingeOuterRadius
//              +hingeClearance
//              +totalOutsideX
//              +latchRodRadius
//              +latchStandoff,
//            0,
//            -latchBasePosition,
//            0,0,180,
//            latchBasePosition,
//            baseOutsideZ,
//            isLid=false); 
        }
      }
    }
    // make lid
    if (showLid) {
      translate([0, 0, 0]) {
        rotate([0, lidRotate, 0]) {
          lidHinge();
          lid();
//          latchAttach(
//            -totalOutsideX        
//              -hingeSupportRadius
//              -hingeClearance
//              -latchRodRadius
//              -latchStandoff,
//            0,
//            -latchLidPosition,
//            0,0,0,
//            latchLidPosition,
//            lidOutsideZ,
//            isLid=true);
        }
      }
    }
    // make latch
    if (showLatch) {
      translate([
        +hingeSupportRadius
          +hingeClearance
          +totalOutsideX
          +latchRodRadius
          +latchStandoff,
        latchWidth/2,
        -latchBasePosition]) {
        rotate([90, latchRotate, 0]) {
//        makeLatch();
        }
      }
    }
  }
  // show cutaway for debug
  if (showCutout) {
    // show main inside and latch
    translate([
      0, 
      cellWallThickness*2, 
      -baseInsideZ
        +shift
        +eps]) {
      rotate([0, 0, 0]) {
        cube(size=[
          totalOutsideX
          +hingeSupportDiameter*2, 
          totalOutsideY, 
            baseOutsideZ
            +lidOutsideZ]);
      }
    }  
  }
}
//////////////////////////////////////////////////
// Core subroutines

// make the latch
module makeLatch() {
  color(showColor?"pink":undef){
    difference() {
      union() {
        // backbone
        translate([
          latchInsideRadius, 0, 0]) {
          rotate([0, 0, 0]) {
            cube(size=[
              latchThickness, 
              latchLength
                +latchHandle, 
              latchWidth]);
          }
        }
        // latchHandle
        translate([
          latchInsideRadius
            -latchThickness, 
          latchLength
            +latchInsideRadius, 
          0]) {
          rotate([0, 0, -20]) {
            cube(size=[
              latchThickness*2, 
              latchHandle, 
              latchWidth]);
          }
        }
        // outer bottom circle
        translate([0, 0, 0]) {
          rotate([0, 0, 0]) {
            cylinder(
              r=latchOuterRadius, 
              h=latchWidth);
          }
        }
        // outer top circle
        translate([0, latchLength, 0]) {
          rotate([0, 0, 0]) {
            cylinder(
              r=latchOuterRadius, 
              h=latchWidth);
          }
        }
      }
      // cutouts
      union() {
        // -inner bottom circle
        translate([0, 0, -eps*10]) {
          rotate([0, 0, 0]) {
            cylinder(
              r=latchInsideRadius, 
              h=latchWidth+eps*20);
          }
        }
        // -inner top circle
        translate([
          0, 
          latchLength, 
          -eps*10]) {
          rotate([0, 0, 0]) {
            cylinder(
              r=latchInsideRadius, 
              h=latchWidth+eps*20);
          }
        }

        // -long rect (backbone)
        translate([-eps, 0, -eps*10]) {
          rotate([0, 0, 0]) {
            cube(size=[
              latchInsideRadius
                +eps*2, 
              latchLength, 
              latchWidth
                +eps*20]);
          }
        }
        // -short top square (closure hook)
        translate([
          -latchInsideRadius
            -latchThickness*1, 
          latchLength
            -latchOuterRadius*1, 
          -eps*10]) {
          rotate([0, 0, 0]) {
            cube(size=[
              latchOuterRadius*2
                -latchThickness, 
              latchOuterRadius, 
              latchWidth
                +eps*20]);
            cube(size=[
              latchOuterRadius
                -latchThickness, 
              latchOuterRadius
                +0.6, // tightness .5-.7
              latchWidth
                +eps*20]);
          }
        }
        // -short bottom angle (attachment)
        translate([0, 0, -eps*10]) {
          rotate([
            0, 
            0, 
            25  // tightness 25-35
            ]) {
            cube(size=[
              latchInsideRadius, 
              latchOuterRadius, 
              latchWidth
                +eps*20]);
          }
        }
      }
    }
  }
}
// make the latch attachment
module latchAttach(
        posX,posY,posZ,
        rotX,rotY,rotZ,
        latchPos,totalZ,isLid) {
  translate([posX,posY,posZ]) {
    rotate([rotX,rotY,rotZ]) {
      makeCoreLatchHalf(
        latchPos,totalZ,isLid);
      translate([0, 0, 0]) {
        mirror([0, 1, 0]) {
          makeCoreLatchHalf(
            latchPos,totalZ,isLid);
        }
      }
    }
  }
}
// create half of a latch attachment
module makeCoreLatchHalf (
        latchPos,
        totalZ,
        isLid // is this the lid?
      ) {
  tfm = // top filet multiplier
        // if lid & shifted, no top filet
    (isLid) ? (shift) ? 1 : 2 : 2;
  btmAdj = // shift up or down
    (isLid) ? -shift : +shift;
  topPos = // upper cutoff location
    (isLid) ? 
      (shift) ? 
        latchVertical : latchPos -shift 
        : latchPos +shift;
  difference() {
    union() {
      // the full triangular attach
      color(showColor?"aqua":undef){
        hull() {  
          translate([
            0, 
            -(latchRodLength/2), 
            0]) {
            rotate([90, 0, 0]) {
              cylinder(
                r=latchRodRadius, 
                h=latchEndWidth);
            }
          }
          translate([
            latchRodRadius
              +latchStandoff, 
            -(latchRodLength/2 
              +latchEndWidth), 
            -latchVertical]) {
            rotate([0, -90, 0]) {
              cube(size=[
                latchVertical
                  *tfm, // = 1 or 2
                latchEndWidth, 
                eps]);
            }
          }
        }
      }   
      // the rod
      color(showColor?"aquamarine":undef){
        hull() {
          translate([0, 0, 0]) {
            rotate([90, 90, 0]) {
              cylinder(
                h=latchRodLength/2
                  +latchEndWidth,
                r=latchRodRadius);
            }
          }
        }
      }
      // rod printing support
      if (addSupport) {
        translate([
          -latchRodPrintSupportWidth/2,
          0, 
          -latchRodPrintSupportSeparation
            -latchRodRadius]) {
          rotate([180, 0, 0]) {
            cube(size=[
              latchRodPrintSupportWidth, 
              latchWidth/2, 
              totalZ
                -latchPos
                -btmAdj]);
          }
        }
      }
    }
    // trim bottom
    translate([
     latchRodRadius
      +latchStandoff
        +eps*2,
      -latchRodLength/2
        -latchEndWidth
        -eps*20, 
      -totalZ
        +latchPos
        +btmAdj
        -eps]) {
    rotate([0, -180, 0]) {
      cube(size=[
        latchVertical*2
          +eps, 
        (latchRodLength/2
          +latchEndWidth)*2
          +eps,
        latchVertical]);
      }
    }
    // trim top
    translate([
      -latchRodRadius, 
      -latchRodLength
        -latchEndWidth
        -eps, 
      +topPos
        +eps]) {
    rotate([0, 0, 0]) {
      cube(size=[
        (latchRodRadius+latchStandoff)*2
          +eps, 
        (latchRodLength+latchEndWidth)*2
          +eps,
        latchVertical]);
      }
    }
  }
}
// make the lid
module lid() {
  difference() {
    // full lid part
    color(showColor?"royalblue":undef){
      translate([
        -totalOutsideX        
          -hingeSupportRadius
          -hingeClearance, 
        -totalOutsideY*5/10, 
        -lidOutsideZ
          -shift]) {
        rotate([0, 0, 0]) {
          cube(size=[
            totalOutsideX
              +hingeClearance*0, 
            totalOutsideY,
            lidOutsideZ]);
        }
      }
    }
    // cutout lid inside
    if (lidInsideZ>0) { // only if needed
      cellCutout(
        -totalOutsideX        
          -hingeSupportRadius
          -hingeClearance
          +outsideWallThickness,
        -totalOutsideY*5/10        
          +outsideWallThickness,
            lidInsideZ
              +shift,
            lidOutsideZ,
            lidCellWallCutdownZ
              +shift);
    }
    // Magnet Holeas
      cornerHoles(-totalOutsideX-hingeSupportRadius-hingeClearance,
          -totalOutsideY/2,
          -magnetHoleHeight,
          totalOutsideX,
          totalOutsideY,
          -outsideWallThickness/2,
          magnetHoleDiam,
          magnetHoleHeight+eps, bot=false);
  }
      
}
// make the base
module base() {
  color(showColor?"springgreen":undef){
    difference() {
      union() {
        // the base
        difference() { // base minus cells
          union(){ //box plus mounting
          // the full base
          translate([
            +hingeSupportRadius
              +hingeClearance, 
            -totalOutsideY*5/10, 
            -baseOutsideZ
              +shift]) {
            rotate([0, 0, 0]) {
              cube(size=[
                totalOutsideX, 
                totalOutsideY,
                baseOutsideZ]);
            }
          }
        // Mounting Plate
        translate([
            +hingeSupportRadius
              +hingeClearance-plateWidth, 
            -totalOutsideY*5/10-plateWidth, 
            -baseOutsideZ
              +shift]) {
            rotate([0, 0, 0]) {
              cube(size=[
                totalOutsideX+2*plateWidth, 
                totalOutsideY+2*plateWidth,
                plateThick]);
            }
          }
          
          }
          // cutout base inside
          translate([0,0,-baseOutsideZ]){
          cellCutout(
            hingeSupportRadius
              +hingeClearance
              +outsideWallThickness,
            -totalOutsideY*5/10
              +outsideWallThickness,
            baseInsideZ
              -shift,
            baseOutsideZ*2,//stretch and translate down for hole through
            baseCellWallCutdownZ
              -shift);
    
        }
        }
      
    }
    //Screw holes
    cornerHoles(hingeSupportRadius+hingeClearance,
              -totalOutsideY/2,
              -baseOutsideZ+shift-plateThick/2,
              totalOutsideX,
              totalOutsideY,
              plateWidth/2,
              holeDiam,
              2*plateThick);
      // Magnet Holeas
      cornerHoles(hingeSupportRadius+hingeClearance,
          -totalOutsideY/2,
          -magnetHoleHeight,
          totalOutsideX,
          totalOutsideY,
          -outsideWallThickness/2,
          magnetHoleDiam,
          magnetHoleHeight+eps,top=false);
      }
  }
}
// screw holes
module cornerHoles(leftX, topY, zHeight, xL, yL, hole_offset, holeDiam, holeDepth, top=true, bot=true){
union(){ // screw holes
        if(top){
       //top left
       translate([
            leftX-hole_offset, 
            topY-hole_offset,
            zHeight]) {
              cylinder(holeDepth,
              holeDiam/2,
              holeDiam/2
              );
            }
       //top right
       translate([
            leftX-hole_offset, 
            topY+yL+hole_offset,
            zHeight]) {
              cylinder(holeDepth,
              holeDiam/2,
              holeDiam/2
              );
            }
        }
        if(bot){
        //bot left
        translate([
            leftX+hole_offset+xL, 
            topY-hole_offset,
            zHeight]) {
              cylinder(holeDepth,
              holeDiam/2,
              holeDiam/2
              );
            }
        //bottom right
       translate([
            leftX+hole_offset+xL, 
            topY+yL+hole_offset,
            zHeight]) {
              cylinder(holeDepth,
              holeDiam/2,
              holeDiam/2
              );
            }
        }
        } //end screw holes
}



// cutout loop for the cells
module cellCutout(
        posX,
        posY,
        insideZ,
        outsideZ,
        cutdownZ
      ) {
  union() {
    // loops to cutout cells
    for (xi=[0:cellCountX-1]) {
      for (yi=[0:cellCountY-1]) {
        translate([
          posX
            +xi*cellWallThickness
            +xi*cellInsideX, 
          posY
            +yi*cellWallThickness
            +yi*cellInsideY, 
          -insideZ]) {
          rotate([0, 0, 0]) {
            cube(size=[
              cellInsideX, 
              cellInsideY,
              outsideZ
                +eps*20]);
          }
        } 
      }
    }
    // cutout for cell wall height
    translate([
      posX, 
      posY, 
      -cutdownZ]) {
      rotate([0, 0, 0]) {
        cube(size=[
          cellWallCutdownX, 
          cellWallCutdownY, 
          outsideZ
            +eps*20]);
      }
    }   
  }
}
// make a matching lid hinge assembly
module lidHinge() {
  makeFullLidHinge();
  translate([0, 0, 0]) {
    mirror([0, 1, 0]) {
      makeFullLidHinge();
    }
  } 
}
// make both halves of 1 lid hinge
module makeFullLidHinge () {
  makeHalfLidHinge();
  translate([0, -totalOutsideY*4/10, 0]) {
    mirror([0, 1, 0]) {
      makeHalfLidHinge();
    }
  }
}
// create half of a hinge for the lid
module makeHalfLidHinge () {
  difference() {
    color(showColor?"deepskyblue":undef){
      union() {  
        hull() {
          // cylinder
          translate([
            0, 
            -totalOutsideY*3/10,
            0]) {
            rotate([90, 0, 0]) {
              cylinder(
                r = hingeSupportRadius, 
                h = hingeLength);
            }
          }
          // add filet
          translate([
            -hingeSupportRadius
              -hingeClearance, 
            -totalOutsideY*5/10,
            -(hingeSupportRadius
              +hingeClearance*0)*2]) {
            rotate([0, 0, 0]) {
            cube(size = [
              eps, 
              hingeLength,
              hingeClearance]);
            }
          }
        }  
        // attach to lid
        hull() {
          // horizontal
          translate([
            -hingeSupportRadius
              -hingeClearance
              -eps,
            -totalOutsideY*5/10, 
            0]) {
            rotate([0, 0, 0]) {
              cube(size=[
                hingeSupportRadius
                  +hingeClearance
                  +eps, 
                hingeLength, 
                eps]);
            }
          }
          // vertical
          translate([
            -hingeSupportRadius
              -hingeClearance
              -eps,
            -totalOutsideY*5/10, 
            -hingeSupportRadius*2]) {
            rotate([0, -90, 0]) {
              cube(size=[
                eps, 
                hingeLength
                  +eps, 
                eps]);
            }
          }
        }
      }
    }
    // filament cutout
    color(showColor?"red":undef){
      translate([
        0, 
        -totalOutsideY*3/10
          +eps,
        0]) {
        rotate([90, 0, 0]) {
          makeFilamentHole(hingeLength);
        }
      }
    }
    // shorten as needed
    translate([
      hingeSupportRadius,
      -totalOutsideY*5/10   
        -eps*20, 
      -lidOutsideZ
        -shift
        -(hingeSupportRadius
          +hingeClearance)*2]) {
      rotate([0, 270, 0]) {
        cube(size=[
          (hingeSupportRadius
            +hingeClearance)*2
            +eps, 
          hingeLength
            +eps*40, 
          +(hingeSupportRadius
            +hingeClearance)*2
            +eps]);
      }
    }
  }
}
// make a matching base hinge assembly
module baseHinge() {
  makeFullBaseHinge();
  translate([0, 0, 0]) {
    mirror([0, 1, 0]) {
      makeFullBaseHinge();
    }
  } 
}
// make both halves of 1 base hinge
module makeFullBaseHinge () {
 makeHalfBaseHinge();
  translate([0, -totalOutsideY*4/10, 0]) {
    mirror([0, 1, 0]) {
      makeHalfBaseHinge();
    }
  } 
}
// create half of a hinge for the base
module makeHalfBaseHinge () {
  difference() {
    color(showColor?"lightgreen":undef){
      union() {
        hull() {
          // cylinder
          translate([
            0,
            -hingeLength
              +hingeClearance, 
            0]) {
            rotate([90, 0, 0]) {
              cylinder(
                r = hingeOuterRadius, 
                h = hingeLength/2);
            }
          }
          // add filet
          translate([
            hingeOuterRadius
              +hingeClearance, 
            -totalOutsideY*3/10
              +hingeClearance,
            -(hingeOuterRadius
              +hingeClearance)*2]) {
            rotate([0, 0, 0]) {
            cube(size = [
              eps, 
              hingeLength/2,
              hingeClearance]);
            }
          }
        }
        // attach to base
        // make a 45 degree triangle
        hull() {
          // horizontal
          translate([
            0,
            -totalOutsideY*3/10   
              +hingeClearance, 
            0]) {
            rotate([0, 0, 0]) {
              cube(size=[
                hingeOuterRadius
                  +hingeClearance
                  +eps, 
                hingeLength/2
                  -eps*2, 
                eps]);
            }
          }
          // vertical
          translate([
            hingeOuterRadius
              +hingeClearance
              +eps,
            -totalOutsideY*3/10   
              +hingeClearance, 
            -(hingeOuterRadius
              +hingeClearance)*2]) {
            rotate([0, -90, 0]) {
              cube(size=[
                eps, 
                hingeLength/2
                  +eps, 
                eps]);
            }
          }
        }
      }
    }
    // filament cutout
    color(showColor?"red":undef){
      translate([
        0, 
        -hingeLength
          +hingeClearance
          +eps, 
        0]) {
        rotate([90, 0, 0]) {
          makeFilamentHole(hingeLength/2);
        }
      }
    }
    // shorten as needed
    translate([
      -hingeOuterRadius,
      -totalOutsideY*3/10   
        +hingeClearance
        -eps*2, 
      -baseOutsideZ
        +shift
        -eps*0]) {
      rotate([0, 90, 0]) {
        cube(size=[
          hingeOuterRadius
            +hingeClearance*2
            +eps*0, 
          hingeLength/2
            +eps*4, 
          +(hingeOuterRadius
              +hingeClearance)*2
            +eps*2]);
      }
    }
  }
}
// create the hole for the filament
module makeFilamentHole(
        length // length to cut
      ) {
  hull() {
    // cut the main hole
    translate([0, 0, 0]) {
      rotate([0, 0, 0]) {
        cylinder(
          r = filamentRadius
                + filamentClearance,
          h = length + eps*2);
      }
    }
    // add small taper above
    // to prevent need to ream out
    translate([
      0,
      filamentRadius
        +filamentClearance,
      0]) {
      rotate([0, 0, 0]) {
        cylinder(
          r = filamentRadius*0.1,
          h = length + eps*2);
      }
    }
  }
}