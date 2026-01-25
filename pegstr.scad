// PEGSTR - Pegboard Wizard
// Design by Marius Gheorghescu, November 2014
// Update log:
// November 9th 2014
//		- first coomplete version. Angled holders are often odd/incorrect.
// November 15th 2014
//		- minor tweaks to increase rendering speed. added logo. 
// November 28th 2014
//		- bug fixes

// preview[view:north, tilt:bottom diagonal]

/* [Holder Size] */

// width of the orifice
Holder_Width = 10; //.1

// depth of the orifice
Holder_Depth = 10; //.1

// hight of the holder
Holder_Height = 15; //.1

// make sure the holder doesn't exceed the holder height.
Strict_Holder_Height = false;

/* [Holder Counts] */

// how many holders along the pegboard
Holder_Count_Wide = 1; // [0:50]

// how many holders outward from the pegboard
Holder_Count_Deep = 2; // [1:25]

/* [Holder Modifiers] */

// orifice corner radius (roundness).
Corner_Radius = 0; //.1

// for bins: The wall thickness to use for closing the bottom
Bottom_Thickness = 2; //.1

// The angle to taper the hole. The taper starts at the top and tapers inward
Taper_Angle = 0; // [0:89]

// Have the holder open below the taper. This is ignored if you have a bottom thickness
Hole_Below_Taper = false;

// Width of the lower hole
Lower_Holder_Hole_Diameter = 0; //.1

// The minimum height of the hole below the taper. This will reduce the height of the holder height above the hole by the same amount. The hole may be deeper if you are not using Scrict Holder Height. This is ignored if you have a bottom thickness
Lower_Holder_Hole_Height_Minimum = 0;

// What percentage cu cut in the front (example to slip in a cable or make the tool snap from the side)
holder_front_slot_width = 10; // [0:100]

/* [Holder Positioning Adjustments] */

// Distance between holders along the pegboard (it will not go below Wall_Thickness)
holder_spacing_x = 0.00; //.1
// Distance between holders outward from the pegboard (it will not go below Wall_Thickness)
holder_spacing_y = 0.00; //.1

// offset from the peg board, typically 0 unless you have an object that needs clearance
Offset_From_Pegboard = 0.0; //.1

// Distance to step down each holder row out from the pegboard
Step_Offset_Amount = 5;

// set an angle for the holder to prevent object from sliding or to view it better from the top
Holder_Angle = 0.0; // [-45:80]



/* [Holder Strength] */

// How thick are the walls. Hint: 6*extrusion width produces the best results.
Wall_Thickness = 1.85;

// How much to reinforce the holders [0-100%]
Strength_Factor_Percent = 0; // [0:100]

// Have pins for every hole in the pegboard. Default: false (only pins on top and bottom rows)
Full_Array_Of_Pins = false;

/* [Pegboard Info] */

// Distance between pins (default 25.4)
hole_spacing = 25.4; //.01
// The diameter of the pegs (default: 5.8)
Peg_Size = 5.8; // [3 : 0.1 : 8.4]

// How thick the pegboard is (default 5.0)
Pegboard_Thickness = 5.00; //.01

/* [Hidden] */

taper_ratio = Taper_Angle; // / 100;

strength_factor = Strength_Factor_Percent / 100;
holder_height = max(Holder_Height + Bottom_Thickness, 0);
holder_angle = -Holder_Angle;
x_spacing = max(Holder_Width + Wall_Thickness, Holder_Width + holder_spacing_x);
y_spacing = max(Holder_Depth + Wall_Thickness, Holder_Depth + holder_spacing_y);
holder_x_size = max(Holder_Width + Wall_Thickness, Holder_Width + holder_spacing_x);
holder_y_size = max(Holder_Depth + Wall_Thickness, Holder_Depth + holder_spacing_y);
holder_sides = max(50, min(20, holder_x_size * 2));

holder_total_x = Holder_Count_Wide * (x_spacing);
holder_total_y = Holder_Count_Deep * (y_spacing);
holder_roundness = min(Corner_Radius, Holder_Depth / 2, Holder_Height / 2);

shrink = tan(abs(Taper_Angle)) * (holder_height - Bottom_Thickness == 0 ? Lower_Holder_Hole_Height_Minimum : 0);

// Compute global bottom size (used only for tapered corners)
bottom_holder_x_size =
  Lower_Holder_Hole_Diameter == 0 ?
    max(0.01, (Holder_Depth) - (Taper_Angle > 0 ? 2 * shrink : -2 * shrink))
  : Lower_Holder_Hole_Diameter;
bottom_holder_y_size =
  Lower_Holder_Hole_Diameter == 0 ?
    max(0.01, (Holder_Width) - (Taper_Angle > 0 ? 2 * shrink : -2 * shrink))
  : Lower_Holder_Hole_Diameter;

moveY = holder_angle < 0 ? (holder_height + Wall_Thickness / 2) * tan(holder_angle) : 0; //this isn't quite right but close enough

pegboard_height =
max(
  (strength_factor * .5 * (holder_height + (Step_Offset_Amount * Holder_Count_Deep)) ) + holder_height,
  hole_spacing + Peg_Size
);

//- hole_size - wall_thickness;
pegboard_width = max((strength_factor * .5 * holder_total_x) + holder_total_x, hole_spacing + Peg_Size);

// what is the $fn parameter for holders
$fn = $preview ? 32 : 64;

epsilon = 0.1;
holder_cutout_side = holder_front_slot_width / 100;
clip_height = 2 * Peg_Size;

$fs = 1;
echo(str("holder_x_size: ", holder_x_size));
echo(str("holder_y_size: ", holder_y_size));
echo(str("bottom_holder_x_size: ", bottom_holder_x_size));
echo(str("bottom_holder_y_size: ", bottom_holder_y_size));
echo(str("holder_total_x: ", holder_total_x));
echo(str("holder_total_y: ", holder_total_y));
echo(str("holder_roundness: ", holder_roundness));
echo(str("x_spacing: ", x_spacing));
echo(str("y_spacing: ", y_spacing));
echo(str("clip_height: ", clip_height));
echo(str("pegboard_width: ", pegboard_width));
echo(str("pegboard_height: ", pegboard_height));
echo(str("Bottom_Thickness: ", Bottom_Thickness));
echo(str("holder_cutout_size: ", Holder_Width * holder_cutout_side));
echo(str("Holder_Width: ", Holder_Width));
echo(str("Holder_Depth: ", Holder_Depth));
echo(str("hole_spacing: ", hole_spacing));
echo("moveY", moveY);

module round_rect_ex(x, y, z, radius, taper_angle, corner_mask = [1, 1, 1, 1], taper_mask = [1, 1, 1, 1]) {

  $fn = holder_sides;
  cornerMask = radius > 0 ? corner_mask : [0, 0, 0, 0];
  shrink = tan(abs(taper_angle)) * z;

  // Compute global bottom size (used only for tapered corners)
  x2 = max(0.01, x - (taper_angle > 0 ? 2 * shrink : -2 * shrink));
  y2 = max(0.01, y - (taper_angle > 0 ? 2 * shrink : -2 * shrink));

  scale = x2 / x;
  radiusBottom = min(radius * scale, min(x2, y2) / 2);
  h = 1;
  // Corner order: TL, TR, BL, BR
  corner_list = [
    [-1, 1], // TL
    [1, 1], // TR
    [-1, -1], // BL
    [1, -1], // BR
  ];

  hull() {

    // --- TOP FACE ---
    for (i = [0:3]) {
      sx = corner_list[i][0];
      sy = corner_list[i][1];

      if (cornerMask[i]) {
        // Rounded corner → place cylinder inset by radius
        translate([sx * (x / 2 - radius), sy * (y / 2 - radius), (z) / 2 - .5])
          cylinder(r=radius, h=1, center=true);
      } else {
        // Square corner → place tiny cube at the true corner
        translate([sx * ( (x - h) / 2), sy * ( (y - h) / 2), (z - h) / 2])
          cube([h, h, h], center=true);
      }
    }

    // --- BOTTOM FACE ---
    for (i = [0:3]) {
      sx = corner_list[i][0];
      sy = corner_list[i][1];

      // If taper_mask[i] == 0 → no taper → use top size
      bx = taper_mask[i] ? (x2 / 2 - radiusBottom) : (x / 2 - radius);
      by = taper_mask[i] ? (y2 / 2 - radiusBottom) : (y / 2 - radius);
      br = taper_mask[i] ? radiusBottom : radius;

      if (cornerMask[i])
        translate([sx * bx, sy * by, -(z) / 2 + .5])
          cylinder(r=br, h=1, center=true);
      else
        translate(
          [
            sx * (taper_mask[i] ? x2 / 2 : x / 2),
            sy * (taper_mask[i] ? y2 / 2 : y / 2),
            -(z - h) / 2,
          ]
        )
          cube([0.01, 0.01, h], center=true);
    }
  }
}

module pin(clip) {

  h = Pegboard_Thickness;
  r_bend = 5.2; // bend radius
  r_tube = Peg_Size / 2; // tube radius
  angle = -85; // bend angle (degrees)
  r_bend2 = r_bend + 2 * r_tube; // centerline radius of second arc

  overlap = 1; // mm of overlap
  r_bend3 = r_bend + 2 * r_tube - overlap;

  echo(str("hole_size: ", Peg_Size));
  echo(str("pin length (h): ", h));

  if (clip) {
    difference() {
      cylinder(r=r_tube, h=h, center=false);

      translate([-1, -0, -0]) {
        difference() {
          cylinder(r=r_tube + 1, h=h, center=false);
          cylinder(r=r_tube, h=h, center=false);
        }
      }
    }
    // -----------------------------------------
    // 2. Rotate so the bend is created in XY plane
    // -----------------------------------------
    rotate([-90, 0, 0]) {

      // -----------------------------------------
      // 3. Move the bend start to the correct place
      // -----------------------------------------
      // -----------------------------------------
      // Both arcs share the SAME outer translate
      // -----------------------------------------
      translate([-r_bend, -h, 0]) {
        difference() {
          // First arc
          rotate_extrude(angle=angle)
            translate([r_bend, 0, 0])
              circle(r=r_tube);

          // Second arc (same center, larger radius)
          difference() {

            rotate_extrude(angle=angle - 1)
              translate([r_bend, -0, -0]) {
                circle(r=r_tube + 1);
              }

            rotate_extrude(angle=angle - 1)
              translate([r_bend - 1, -0, -0]) {
                circle(r=r_tube);
              }
          }
        }
      }
    }
    // -----------------------------------------
    // 5. Compute arc endpoint (world XY)
    // -----------------------------------------
    end_x = r_bend * cos(angle);
    end_y = r_bend * sin(angle);
  } else {
    // -------------------------------
    // 1. Straight cylinder (vertical)
    // -------------------------------

    cylinder(r=r_tube, h=h, center=false);
  }
}

module pinboard_clips() {

  pegboard_height =
    Full_Array_Of_Pins ? max(
        holder_height + (Step_Offset_Amount * Holder_Count_Deep - 1),
        hole_spacing + Peg_Size
      )
    : pegboard_height;

  rotate([0, 90, 0])for (i = [0:floor((pegboard_width - (Peg_Size)) / hole_spacing)]) {
    for (j = [0:floor(( (pegboard_height - (Peg_Size)) / hole_spacing))]) {
      translate(
        [
          j * hole_spacing + (Peg_Size / 2),
          -hole_spacing * (floor((pegboard_width - (Peg_Size)) / hole_spacing) / 2) + i * hole_spacing,
          0,
        ]
      )
        pin(j == 0);
      echo(
        str(
          "pin location:", [
            j * hole_spacing + (Peg_Size / 2),
            -hole_spacing * (floor((pegboard_width - (Peg_Size)) / hole_spacing) / 2) + i * hole_spacing,
            0,
          ]
        )
      );
    }
  }
}

module pinboard(isStepped = false) {
  difference() {

    rotate([0, 90, 0])
      translate([0, 0, -Wall_Thickness])
        hull() {
          translate(
            [
              Peg_Size / 2,
              -pegboard_width / 2 + (Peg_Size / 2),
              0,
            ]
          ) {
            if (isStepped) {
              cube([Peg_Size, Peg_Size, Wall_Thickness], true);
            } else {
              cylinder(r=Peg_Size / 2, h=Wall_Thickness);
            }
          }
          translate(
            [
              Peg_Size / 2,
              pegboard_width / 2 - (Peg_Size / 2),
              0,
            ]
          ) {
            if (isStepped) {
              cube([Peg_Size, Peg_Size, Wall_Thickness], true);
            } else {
              cylinder(r=Peg_Size / 2, h=Wall_Thickness);
            }
          }
          translate(
            [
              pegboard_height - (Peg_Size / 2),
              -pegboard_width / 2 + (Peg_Size / 2),
              0,
            ]
          )
            cylinder(r=Peg_Size / 2, h=Wall_Thickness);

          translate(
            [
              pegboard_height - (Peg_Size / 2),
              pegboard_width / 2 - (Peg_Size / 2),
              0,
            ]
          )
            cylinder(r=Peg_Size / 2, h=Wall_Thickness);
        }

    rotate([0, holder_angle, 0]) {
      thickness = Wall_Thickness / cos(holder_angle);
      translate([-thickness, -pegboard_width / 2, 0]) {
        cube([thickness, pegboard_width, 2], center=false);
      }
    }
  }
}

module holderboard() {
  difference() {
    color("LightCoral")
      rotate([0, 90, 0])
        translate([0, 0, -Wall_Thickness])
          hull() {
            translate(
              [
                Peg_Size / 2,
                -pegboard_width / 2 + (Peg_Size / 2),
                0,
              ]
            )
              cylinder(r=Peg_Size / 2, h=Wall_Thickness);

            translate(
              [
                Peg_Size / 2,
                pegboard_width / 2 - (Peg_Size / 2),
                0,
              ]
            )
              cylinder(r=Peg_Size / 2, h=Wall_Thickness);

            translate(
              [
                Holder_Height - Peg_Size / 2,
                -pegboard_width / 2 + (Peg_Size / 2),
                0,
              ]
            )
              cylinder(r=Peg_Size / 2, h=Wall_Thickness);

            translate(
              [
                Holder_Height - Peg_Size / 2,
                pegboard_width / 2 - (Peg_Size / 2),
                0,
              ]
            )
              cylinder(r=Peg_Size / 2, h=Wall_Thickness);
          }

    rotate([0, holder_angle, 0]) {
      thickness = Wall_Thickness / cos(holder_angle);
      translate([-thickness, -pegboard_width / 2, 0]) {
        cube([thickness, pegboard_width, 2], center=false);
      }
    }
  }
}

module holders() {
  if (holder_x_size > 0 && holder_y_size > 0) {
    // for (x = [0:0]) {
    for (y = [0:Holder_Count_Deep - 1]) {
      // move holder to correct position
      //translateZ =  -(holder_height / 2) * sin(holder_angle) - ((holder_height/2) - hole_size)  ;

      translateZ = -( (holder_height / 2) + (Step_Offset_Amount > 0 && y > 0 ? y * Step_Offset_Amount : 0));
      translateX = -(y * (holder_y_size)) - holder_y_size / 2 - sin(holder_angle) - Offset_From_Pegboard - Wall_Thickness + moveY;
      translateY = 0; //-holder_total_x / 2;// + x_spacing / 2 + (x) * x_spacing + Wall_Thickness / 2;
      echo(
        "Translating Holder by:",
        translateX=translateX,
        translateY=translateY,
        translateZ=translateZ
      );
      translate(
        [
          // X
          translateX,
          // Y
          translateY,
          // Z
          translateZ,
        ]
      ) {
        // 0 = false, 1 = true
        frontLeftCornerMask = Holder_Count_Deep > 1 && y + 1 < Holder_Count_Deep ? 0 : 1;
        frontRightCornerMask = Holder_Count_Deep > 1 && y + 1 < Holder_Count_Deep ? 0 : 1;
        backLeftCornerMask = y == 0 || (Holder_Count_Deep > 1 && y > 0) ? 0 : 1;
        backtRightCornerMask = y == 0 || (Holder_Count_Deep > 1 && y > 0) ? 0 : 1;

        frontLeftTaperMask = Holder_Count_Deep > 1 && y + 1 < Holder_Count_Deep ? 0 : 1;
        frontRightTaperMask = Holder_Count_Deep > 1 && y + 1 < Holder_Count_Deep ? 0 : 1;
        backLeftTaperMask = y == 0 || (Holder_Count_Deep > 1 && y > 0) ? 0 : 1;
        backtRightTaperMask = y == 0 || (Holder_Count_Deep > 1 && y > 0) ? 0 : 1;

        echo("Creating Holder ", y=y);
        echo(
          x=holder_y_size,
          "round_rect_ex args:",
          y=holder_total_x,
          z=holder_height,
          r=holder_roundness,
          taper_angle=Taper_Angle,
          corner_mask=[frontLeftCornerMask, backLeftCornerMask, frontRightCornerMask, backtRightCornerMask],
          taper_mask=[frontLeftTaperMask, backLeftTaperMask, frontRightTaperMask, backtRightTaperMask]
        );

        hull() {

          // Undo outer translate
          translate([-translateX, -translateY, -translateZ])

            // Undo rotation
            rotate([0, -holder_angle, 0])

              translate(
                [
                  0,
                  0,
                  -(Step_Offset_Amount) * y,
                ]
              ) {
                if (Strict_Holder_Height && y == 0) {
                  holderboard();
                } else if (!Strict_Holder_Height) {
                  pinboard(true);
                }
              }
          round_rect_ex(
            holder_y_size,
            holder_total_x,
            holder_height,
            holder_roundness,
            Taper_Angle,
            corner_mask=[frontLeftCornerMask, backLeftCornerMask, frontRightCornerMask, backtRightCornerMask],
            taper_mask=[frontLeftTaperMask, backLeftTaperMask, frontRightTaperMask, backtRightTaperMask]
          );
        }
      }
    }
  }
}

module holder_holes() {

  height = (Bottom_Thickness > 0 ? Holder_Height : max(holder_height, Strict_Holder_Height ? holder_height : pegboard_height)) + .2;

  if (holder_x_size > 0 && holder_y_size > 0) {

    // --- HEIGHTS ---
    H1 = height - (Bottom_Thickness == 0 ? Lower_Holder_Hole_Height_Minimum : Bottom_Thickness); // purple block height
    H2 = height - H1;

    for (x = [1:Holder_Count_Wide]) {
      for (y = [0:Holder_Count_Deep - 1]) {
        translateX = -(y * (holder_y_size)) - holder_y_size / 2 - Wall_Thickness - abs(sin(holder_angle)) - Offset_From_Pegboard + moveY;
        translateY = -(holder_total_x / 2) + (holder_x_size / 2) + (x - 1) * x_spacing; // + Wall_Thickness / 2;
        translateZ = -H1 / 2 - (Step_Offset_Amount > 0 && y > 0 ? y * Step_Offset_Amount : 0) + .1;
        translateZ2 = translateZ - H1 / 2 - H2 / 2;
        // ---------------------------
        //  PURPLE MAIN HOLDER BLOCK
        // ---------------------------
        translate(
          [
            // X
            translateX,

            // Y
            translateY,

            // Z
            translateZ,
          ]
        ) {

          echo(
            "round_rect_ex args:",
            x=Holder_Depth,
            y=Holder_Width,
            z=holder_height,
            r=holder_roundness,
            taper_angle=Taper_Angle
          );
          color("yellow")
            round_rect_ex(
              Holder_Depth,
              Holder_Width,
              H1,
              holder_roundness,
              Taper_Angle
            );
        }

        // ---------------------------
        //  EXTENSION
        // ---------------------------
        if ( (taper_ratio != 1 || Lower_Holder_Hole_Diameter) && Hole_Below_Taper && Bottom_Thickness == 0) {
          echo(translateZ=translateZ, H1=H1, H2=H2, holder_height=holder_height, Step_Offset_Amount=Step_Offset_Amount);
          scale = bottom_holder_x_size / Holder_Depth;
          radiusBottom =
            Lower_Holder_Hole_Diameter == 0 ?
              min(holder_roundness * scale, min(bottom_holder_x_size, bottom_holder_y_size) / 2)
            : bottom_holder_x_size / 2;
          translate(
            [
              // X
              translateX,
              // Y
              translateY,
              // Z
              translateZ - (pegboard_height + ( (Holder_Count_Deep - y) * Step_Offset_Amount)) / 2, // - (H2/2) //-(H1 + H2), //(translateZ - holder_height + (H2 / 2)),
            ]
          ) {

            color("green")
              round_rect_ex(
                x=bottom_holder_x_size,
                y=bottom_holder_y_size,
                z=pegboard_height + ( (Holder_Count_Deep - y) * Step_Offset_Amount),
                radius=radiusBottom,
                taper_angle=0
              );
          }
        }
      }
      // y loop
    }
    // x loop
  }
}

module holder_front_cutout() {

  if (holder_front_slot_width > 0) {
    height = (Bottom_Thickness > 0 ? Holder_Height : max(holder_height, Strict_Holder_Height ? holder_height : pegboard_height)) + .2;
    echo("cutout height:", height);
    if (holder_x_size > 0 && holder_y_size > 0) {

      // --- HEIGHTS ---
      H1 = height;
      H2 = max(holder_height, pegboard_height) - height;

      cutoutDepth = Holder_Depth + x_spacing; // - Wall_Thickness + .1;

      for (x = [1:Holder_Count_Wide]) {
        for (y = [0:Holder_Count_Deep - 1]) {
          translateX = -(y * (holder_y_size)) - Holder_Width / 2 - Wall_Thickness - abs(sin(holder_angle)) - Offset_From_Pegboard - cutoutDepth / 2 + moveY - (Wall_Thickness / 2);
          translateY = -holder_total_x / 2 + x_spacing / 2 + (x - 1) * x_spacing + Wall_Thickness / 2;
          translateZ = -(height / 2) - (Step_Offset_Amount > 0 && y > 0 ? y * Step_Offset_Amount : 0) + .1;
          echo(
            "Translating Cutout by:",
            translateX=translateX,
            translateY=translateY,
            translateZ=translateZ
          );
          // ---------------------------
          //  PURPLE MAIN HOLDER BLOCK
          // ---------------------------
          translate(
            [
              // X
              translateX,

              // Y
              translateY,

              // Z
              translateZ,
            ]
          ) {

            color("blue")
              round_rect_ex(
                cutoutDepth,
                Holder_Width * holder_cutout_side,
                H1,
                0,
                0,
                corner_mask=[1, 0, 0, 1]
              );
          }

          // ---------------------------
          //  GREEN TAPER EXTENSION
          // ---------------------------
          if (taper_ratio != 1 && Hole_Below_Taper && Bottom_Thickness == 0) {
            translate(
              [
                // X
                translateX,
                // Y
                translateY,
                // Z
                -(height + H2 / 2), //(translateZ - holder_height + (H2 / 2)),
              ]
            ) {

              color("green")
                round_rect_ex(
                  x=cutoutDepth,
                  y=Holder_Width * holder_cutout_side,
                  z=H2,
                  radius=0,
                  taper_angle=0
                );
            }
          }
        }
        // y loop
      }
      // x loop
    }
  }
}

module finalHolder() {

  if (!Strict_Holder_Height && Step_Offset_Amount == 0) {
    difference() {
      hull() {
        pinboard();
        rotate([0, holder_angle, 0])
          holders();
      }
      rotate([0, holder_angle, 0]) {
        holder_holes();
        holder_front_cutout();
      }
    }
  } else {

    //union() {
    pinboard();
    //holderboard();
    rotate([0, holder_angle, 0]) {
      difference() {
        holders();
        holder_holes();
        holder_front_cutout();
      }
    }
    //}
  }
}

module pegstr() {
  //union() {

  finalHolder();
  color("Blue")
    pinboard_clips();
  // }
}

pegstr();
