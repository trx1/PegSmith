// PegSmith - Advanced Pegboard Wizard
// Written By Chad Urvig, January 2026
// Original Design by Marius Gheorghescu, November 2014 (PEGSTR)

/* [Holder Size] */

// width of the orifice
Holder_Width = 30; //.1

// depth of the orifice
Holder_Depth = 10; //.1

// hight of the holder
Holder_Height = 15; //.1

/* [Holder Counts] */

// how many holders along the pegboard
Holder_Count_Wide = 2; // [0:50]

// how many holders outward from the pegboard
Holder_Count_Deep = 2; // [1:25]

/* [Holder Modifiers] */

// Orifice corner radius (roundness).
Corner_Radius = 0; //.1

//How thick the bottom of the holder should be.
Bottom_Thickness = 2; //.1

// The angle to taper the hole. The taper starts at the top and tapers inward
Taper_Angle = 0; // [0:89]

Lower_Holder_Hole_Width = 0; //.1
Lower_Holder_Hole_Depth = 0; //.1

// Width of the front slot (example to slip in a cable or make the tool snap from the side)
Holder_Front_Slot_Width = 0; //.1

/* [Holder Positioning Adjustments] */

// Distance between holders along the width of the pegboard (it will not go below Wall_Thickness)
Holder_Spacing_x = 0.00; //.1
// Distance between holders outward from the pegboard (it will not go below Wall_Thickness)
Holder_Spacing_y = 0.00; //.1

// offset from the peg board, typically 0 unless you have an object that needs clearance
Offset_From_Pegboard = 0.0; //.1

// Distance to step down each holder row out from the pegboard
Step_Offset_Amount = 5;

// offset holders on each row for better visibility. Every other row will have one less holder.
Offset_Holder_Rows = false;

// set an angle for the holder to prevent object from sliding or to view it better from the top
Holder_Angle = 15; // [-80:45]

/* [Holder Strength] */

// How thick are the walls. Hint: 6*extrusion width produces the best results.
Wall_Thickness = 2;

// How much to reinforce the holders [0-100%]
Strength_Factor_Percent = 0; // [0:100]

// Have pins for every hole in the pegboard. Default: false (only pins on top and bottom rows)
Full_Array_Of_Pins = false;

/* [Pegboard Info] */

// Distance between pins (default 25.4)
hole_spacing = 25.4; //.01
// The diameter of the pegs (default: 5.8)
Peg_Size = 5.8; //.01

// How thick the pegboard is (default 5.0)
Pegboard_Thickness = 5.00; //.01

/* [Hidden] */

Strict_Holder_Height = true; //remove this
taper_angle = -Taper_Angle;

strength_factor = Strength_Factor_Percent / 100;
holder_height = max(Holder_Height + Bottom_Thickness, 0);
holder_angle = Holder_Angle;
holder_spacing_x = max(Wall_Thickness, Holder_Spacing_x);
holder_spacing_y = max(Holder_Spacing_y);
holder_width = Holder_Width; // + holder_spacing_x;
holder_depth = Holder_Depth; // + holder_spacing_y;
holder_sides = max(50, min(20, holder_depth * 2));

top_holder_roundness = min(Corner_Radius, holder_depth / 2, holder_width / 2);
holder_front_slot_width = min(Holder_Front_Slot_Width, holder_width);
shrink = tan(abs(Taper_Angle)) * (holder_height);

bottom_holder_width = max(0.01, (holder_width) - (Taper_Angle > 0 ? 2 * shrink : -2 * shrink));
bottom_holder_depth = max(0.01, (holder_depth) - (Taper_Angle > 0 ? 2 * shrink : -2 * shrink));
bottom_holder_roundness = min(Corner_Radius, bottom_holder_width / 2, bottom_holder_depth / 2);
lower_holder_hole_roundness = min(Corner_Radius, Lower_Holder_Hole_Width / 2, Lower_Holder_Hole_Depth / 2);
bottom_holder_hole_roundness = min(Corner_Radius, Lower_Holder_Hole_Depth / 2, Lower_Holder_Hole_Width / 2);

holder_total_depth = Holder_Depth + holder_spacing_y + (Wall_Thickness * 2);
holder_total_bottom_depth = (holder_total_depth - bottom_holder_depth) / 2 + holder_spacing_y;

holder_total_width = (Holder_Count_Wide * (holder_width)) + ( (Holder_Count_Wide - 1) * (holder_spacing_x)) + (Wall_Thickness * 2);
holder_total_width_offset = holder_total_width - holder_width - Wall_Thickness; // (Holder_Count_Wide - 1) * (holder_width + holder_spacing_x + Wall_Thickness) - holder_spacing_x + Wall_Thickness;
pegboard_height =
max(

  (holder_height + (Step_Offset_Amount * (Holder_Count_Deep - 1))) * cos(holder_angle),
  hole_spacing + Peg_Size
);

//- hole_size - wall_thickness;
pegboard_width = max((strength_factor * .5 * holder_total_width) + holder_total_width, hole_spacing + Peg_Size);

// what is the $fn parameter for holders
$fn = $preview ? 16 : 64;

epsilon = 0.1;
clip_height = 2 * Peg_Size;

$fs = 1;
echo("shrink: ", shrink);
echo(str("holder_depth: ", holder_depth));
echo(str("holder_width: ", holder_width));
echo(str("Holder_Spacing_x: ", Holder_Spacing_x));
echo(str("Holder_Spacing_y: ", Holder_Spacing_y));
echo(str("holder_height: ", holder_height));
echo(str("bottom_holder_width: ", bottom_holder_width));
echo(str("bottom_holder_depth: ", bottom_holder_depth));
echo(str("Lower_Holder_Hole_Width: ", Lower_Holder_Hole_Width));
echo(str("Lower_Holder_Hole_Depth: ", Lower_Holder_Hole_Depth));
echo(str("holder_total_depth: ", holder_total_depth));
echo(str("holder_total_width_offset: ", holder_total_width_offset));
echo(str("holder_total_width: ", holder_total_width));
echo(str("top_holder_roundness: ", top_holder_roundness));
echo(str("bottom_holder_roundness: ", bottom_holder_roundness));
echo(str("clip_height: ", clip_height));
echo(str("pegboard_width: ", pegboard_width));
echo(str("pegboard_height: ", pegboard_height));
echo(str("hole_spacing: ", hole_spacing));

/*
 * Preview color - applies color only in preview mode
 * @param color Color to apply during preview
 */
module pColor(color) {
  if ($preview) {
    color(color) children();
  }
  else
    children();
}

/*
 * Final color - applies color only in render mode
 * @param color Color to apply during final render
 */
module fColor(color) {
  if (!$preview) {
    color(color) children();
  }
  else
    children();
}
/*
 * Creates a 3D tapered rounded box with independent top and bottom dimensions
 * Supports selective corner rounding and different radii for top and bottom
 * @param topX Width at top
 * @param topY Depth at top
 * @param z Height of the box
 * @param bottomX Width at bottom (defaults to topX)
 * @param bottomY Depth at bottom (defaults to topY)
 * @param radius Corner radius at top (default 0)
 * @param radiusBottom Corner radius at bottom (defaults to radius)
 * @param radiusCorners_mask [TL, TR, BL, BR] - which corners to round (default [1,1,1,1])
 */ module tapered_rounded_box(topX, topY, z, bottomX, bottomY, radius = 0, radiusBottom, radiusCorners_mask = [1, 1, 1, 1]) {
  $fn = holder_sides;
  _radiusBottom = radiusBottom == undef ? radius : radiusBottom;
  _radiusCornersMask = radius > 0 ? radiusCorners_mask : [0, 0, 0, 0];
  _radiusBottomCornersMask = _radiusBottom > 0 ? radiusCorners_mask : [0, 0, 0, 0];
  _bottomX = is_undef(bottomX) ? topX : bottomX;
  _bottomY = is_undef(bottomY) ? topY : bottomY;

  // echo(
  //   "tapered_rounded_box",
  //   topX=topX,
  //   topY=topY,
  //   bottomX=bottomX,
  //   bottomY=bottomY,
  //   z=z,
  //   radius=radius,
  //   radiusBottom=radiusBottom,
  //   radiusCorners_mask=_radiusCornersMask
  // );
  h = .1;
  // Corner order: TL, TR, BL, BR
  corner_list = [
    [-1, 1], // TL
    [1, 1], // TR
    [-1, -1], // BL
    [1, -1], // BR
  ];
  hull() {

    // --- Create top and bottom corners ---
    for (i = [0:3]) {
      let (
        topY = topY - h,
        topX = topX - h,
        _bottomY = _bottomY - h,
        _bottomX = _bottomX - h
      ) {
        _radiusBottom = is_undef(radiusBottom) ? radius : (_radiusCornersMask[i] ? radiusBottom : 0);
        tx = corner_list[i][0] * (topX / 2 - (_radiusCornersMask[i] ? radius : 0));
        ty = corner_list[i][1] * (topY / 2 - (_radiusCornersMask[i] ? radius : 0));
        tz = z / 2;
        bx = corner_list[i][0] * (_bottomX / 2 - (_radiusBottomCornersMask[i] ? _radiusBottom : 0));
        by = corner_list[i][1] * (_bottomY / 2 - (_radiusBottomCornersMask[i] ? _radiusBottom : 0));
        bz = -(z / 2) + h;

        // echo(tz, bz);
        if (_radiusCornersMask[i]) {
          // Rounded corner -> place cylinder inset by radius
          translate([tx, ty, tz])
            cylinder(r2=radius, r1=_radiusBottom, h=h, center=true);
        } else {
          // Square corner -> place tiny cube at the true corner
          translate([tx, ty, tz])
            cube([h, h, h], center=true);
        }
        if (_radiusBottomCornersMask[i]) {
          //   cylinder(r=radius, h=h, center=true);
          translate([bx, by, bz])
            cylinder(r=_radiusBottom, h=h, center=true);
        } else {
          // Square corner -> place tiny cube at the true corner
          translate([bx, by, bz])
            cube([h, h, h], center=true);
        }
      }
    }
  }
}

function clamp(x, lo, hi) = x < lo ? lo : x > hi ? hi : x;

/*
 * Creates a pegboard mounting pin
 * @param clip If true, creates a pin with a bent clip; if false, creates a straight cylinder
 */
module pin(clip) {

  h = Pegboard_Thickness;
  r_bend = clamp(5.2 / (5.8 / Peg_Size), 3, 8); // bend radius
  r_tube = Peg_Size / 2; // tube radius
  angle = -85; // bend angle (degrees)

  translate([0, -0, +Wall_Thickness]) if (clip) {
    difference() {
      cylinder(r=r_tube, h=h, center=false);

      translate([-1, -0, 0]) {
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

/*
 * Generates array of pegboard mounting pins across the full pegboard surface
 */
module pinboard_clips() {

  pegboard_height =
    Full_Array_Of_Pins ? pegboard_height
    : hole_spacing + Peg_Size;

  rotate([0, 90, 0]) {
    for (i = [0:floor((pegboard_width - (Peg_Size)) / hole_spacing)]) {
      for (j = [0:floor(( (pegboard_height - (Peg_Size)) / hole_spacing))]) {
        translate(
          [
            j * hole_spacing + (Peg_Size / 2),
            -hole_spacing * (floor((pegboard_width - (Peg_Size)) / hole_spacing) / 2) + i * hole_spacing,
            0,
          ]
        )
          pin(j == 0);
      }
    }
  }
}

/*
 * Creates the main mounting board that attaches to the pegboard
 */
module pinboard() {
  thickness = Wall_Thickness;
  boardHeight = (pegboard_height); //* cos(holder_angle); // - (Peg_Size / 2);
  pColor(rands(0, 1, 3)) {
    translate([thickness / 2, 0, -boardHeight / 2])
      cube([thickness, pegboard_width, boardHeight], center=true);
  }
}

/*
 * Creates the front-facing holder board (typically unused in final output)
 */
module holderboard() {
  thickness = Wall_Thickness;
  boardHeight = (holder_height); //* cos(holder_angle); // - (Peg_Size / 2);
  pColor(rands(0, 1, 3)) {
    translate([thickness / 2, 0, -boardHeight / 2])
      cube([thickness, pegboard_width, boardHeight], center=true);
  }
}

/*
 * Helper - scales geometry inward by a specified amount from all sides
 * @param amount Distance to shrink inward
 * @param size [x, y, z] original dimensions
 */
module shrink_by(amount, size) {
  sx = (size[0] - 2 * amount) / size[0];
  sy = (size[1] - 2 * amount) / size[1];
  sz = (size[2] - 2 * amount) / size[2];

  translate([amount, amount, amount])
    scale([sx, sy, sz])
      children();
}

/*
 * Creates support structure between holder rows when using step offset
 * @param y Current row index (depth)
 * @param translateZ Vertical offset for this row
 * @param isOuter True for outer support, false for inner
 * @param isLastOffset True if this is the last offset row
 * @param translateY Horizontal offset
 * @param z Height of support
 * @param radius Top corner radius
 * @param radiusBottom Bottom corner radius
 * @param radiusCorners_mask Which corners to round
 */
module holder_row_support(y, translateZ, isOuter, isLastOffset, translateY, z, radius, radiusBottom, radiusCorners_mask) {
  intersection() {
    hull() {
      translate([-Offset_From_Pegboard, 0, 0]) {
        rotate_holder() {

          let (
            translateX = (holder_total_depth / 2) + (Wall_Thickness / 2) - (holder_total_depth * y) + Wall_Thickness + (isOuter ? 0 : Wall_Thickness)
          )
          translate([translateX, 0, translateZ + (isOuter ? 0 : .1)])
            cube([Wall_Thickness, pegboard_width - (isOuter ? 0 : Wall_Thickness * 2), holder_height + (isOuter ? 0 : .5)], center=true);
        }
      }
      translate(
        [
          (Wall_Thickness / 2),
          0,
          translateZ - holder_height / 2 + (isOuter ? 0 : .1),
        ]
      )
        cube([Wall_Thickness, pegboard_width - (isOuter ? 0 : Wall_Thickness * 2), holder_height + (isOuter ? 0 : .5)], center=true);
    }
    if (isLastOffset)
      let (
        topX = holder_total_depth * y - (isOuter ? 0 : Wall_Thickness * 2),
        topY = pegboard_width - (isOuter ? 0 : Wall_Thickness * 2),
        z = z + (isOuter ? 0 : .5),
        translateX = -( (holder_total_depth) * (y - 1) - ( (holder_total_depth / 2) * (y - 1)) - Wall_Thickness),
        translateZ = translateZ + .1
      )
      translate([-Offset_From_Pegboard, 0, 0]) {
        rotate_holder() {

          translate(
            [
              translateX,
              translateY,
              translateZ,
            ]
          ) {

            tapered_rounded_box(
              topX=topX,
              topY=topY,
              z=z,
              radius=isOuter ? radius : radius * (topX / (holder_total_depth * y)),
              radiusBottom=isOuter ? radiusBottom : radiusBottom * (topX / (holder_total_depth * y)),
              radiusCorners_mask=radiusCorners_mask
            );
          }
          translate(
            [
              translateX + holder_total_depth - (Wall_Thickness *2),
              translateY,
              translateZ,
            ]
          ) {
            cube([topX, topY, z], center=true);
          }
        }
      }
  }
}

/*
 * Main container structure that holds all holder rows and connects to pegboard
 * Generates the stepped structure for multi-depth holders with proper reinforcement
 */
module holder_row_container() {
  if (holder_depth > 0 && holder_width > 0) {

    //this is filler geometry that connects the holders to the pegboard plate
    hull() {
      translate([-Offset_From_Pegboard, 0, 0]) {
        rotate_holder() {
          pColor(rands(0, 1, 3)) {
            let (
              translateY = (holder_total_depth / 2) + (Wall_Thickness / 2) // (holder_total_depth / 2) + (Wall_Thickness / 2) - (holder_total_depth * y)
            ) {
              translate([translateY, 0, 0]) {
                cube([Wall_Thickness, pegboard_width, holder_height], center=true);
              }
            }
          }
        }
      }

      translate([Wall_Thickness / 2, 0, -holder_height / 2]) {
        cube([Wall_Thickness, pegboard_width, holder_height], center=true);
      }
    }

    difference() {
      for (y = [0:Holder_Count_Deep - 1]) {

        translateZ = -( (Step_Offset_Amount > 0 && y > 0 ? y * (Step_Offset_Amount) : 0) );
        isLastOffset = !(y % 2 == 0) && Offset_Holder_Rows && (y == Holder_Count_Deep - 1);
        is_even = (y % 2 == 0);
        translateX = -(y * holder_total_depth - Wall_Thickness);
        translateY = 0;
        radiusFrontLeftCorner = (y == Holder_Count_Deep - 1) || (is_even && Offset_Holder_Rows && y == Holder_Count_Deep - 2);
        radiusFrontRightCorner = radiusFrontLeftCorner;
        radiusBackLeftCorner = 0;
        radiusBackRightCorner = 0;
        topX = holder_total_depth;
        topY = isLastOffset ? holder_total_width_offset : pegboard_width;
        z = (holder_height);
        radius = top_holder_roundness + (Wall_Thickness / 2);
        radiusBottom = Step_Offset_Amount > 0 && y == Holder_Count_Deep - 1 ? bottom_holder_roundness + (Wall_Thickness / 2) : radius;
        radiusCorners_mask = [radiusFrontLeftCorner, radiusBackLeftCorner, radiusFrontRightCorner, radiusBackRightCorner];
        isStepped = Step_Offset_Amount > 0 && y > 0;

        if (y > 0 && Step_Offset_Amount > 0) {

          difference() {
            holder_row_support(y=y, translateZ=translateZ, isLastOffset=isLastOffset, isOuter=true, translateY=translateY, z=z, radius=radius, radiusBottom=radius, radiusCorners_mask=radiusCorners_mask);

            holder_row_support(y=y, translateZ=translateZ, isLastOffset=isLastOffset, isOuter=false, translateY=translateY, z=z, radius=radius, radiusBottom=radius, radiusCorners_mask=radiusCorners_mask);
          }
         
        }

        pColor(rands(0, 1, 3)) {

          translate([-Offset_From_Pegboard, 0, 0]) {
            rotate_holder() {
              translate([translateX, translateY, translateZ]) {

                echo("Creating holder row container");
                tapered_rounded_box(
                  topX=topX,
                  topY=topY,
                  // bottomX=bottomX,
                  // bottomY=bottomY,
                  z=z,
                  radius=radius,
                  radiusBottom=radius,
                  radiusCorners_mask=radiusCorners_mask
                );
              }
            }
          }
        }
      }

      

      if (Holder_Angle > 0 && Step_Offset_Amount > 0 && Holder_Count_Deep > 1) {

        outer = [
          [Wall_Thickness, 0], // A
          [Wall_Thickness, -(pegboard_height + Wall_Thickness)], // B
          [-( (pegboard_height + Wall_Thickness) * sin(holder_angle)), -(pegboard_height + Wall_Thickness)], // C
        ];

        translate([0, 0, 0])
          rotate([90, 0, 0])
            linear_extrude(height=pegboard_width - Wall_Thickness * 2, center=true)
              offset(delta=-Wall_Thickness)
                polygon(points=outer);
      }
    }
  }
 
}

/*
 * Subtractive geometry that creates the hollow holder cavities
 * Generates tapered holes with optional bottom extension holes
 */
module holder_holes() {

  holeDepth = (Bottom_Thickness > 0 ? Holder_Height : max(holder_height, Strict_Holder_Height ? holder_height : pegboard_height)) + .2;

  if (Holder_Width > 0 && Holder_Depth > 0) {
    translate([-Offset_From_Pegboard, 0, 0]) {
      for (y = [0:Holder_Count_Deep - 1]) {
        isStepped = Step_Offset_Amount > 0 && y > 0;
        is_even = (y % 2 == 0);
        rotate_holder() {
          spacing = holder_width + holder_spacing_x;

          for (x = [1:Holder_Count_Wide - (is_even || !Offset_Holder_Rows || Holder_Count_Wide == 1 ? 0 : 1)]) {
            total = (Holder_Count_Wide + (!is_even && Offset_Holder_Rows ? 0 : 1)) * spacing;
            offset = -total / 2;
            translateX = -(y * holder_total_depth - Wall_Thickness); // (isStepped ? 0 : Wall_Thickness));
            translateY = (offset + x * spacing);
            translateZ = -(Step_Offset_Amount > 0 && y > 0 ? y * Step_Offset_Amount : 0) + Bottom_Thickness / 2;
            translateZ2 = translateZ - holeDepth / 2;
            // ---------------------------
            //  MAIN HOLDER BLOCK
            // --------------------------
            translate(
              [translateX, translateY, translateZ]
            ) {
              pColor("yellow")

              {
                tapered_rounded_box(
                  topX=Holder_Depth,
                  topY=Holder_Width,
                  z=holeDepth,
                  bottomX=bottom_holder_depth,
                  bottomY=bottom_holder_width,
                  radius=top_holder_roundness,
                  radiusBottom=bottom_holder_roundness
                );
              }
            }

            // ---------------------------
            //  EXTENSION
            // ---------------------------
            if ( (Lower_Holder_Hole_Width > 0 && Lower_Holder_Hole_Depth > 0) && (Bottom_Thickness > 0)) {
              z = Bottom_Thickness + 1;
              translateZ2 = -( (y * Step_Offset_Amount) + holder_height / 2 - z / 2 + .5);

              translate([translateX, translateY, translateZ2]) {

                pColor("green")

                  tapered_rounded_box(
                    topX=(Lower_Holder_Hole_Width > 0 && Lower_Holder_Hole_Depth > 0) ? Lower_Holder_Hole_Depth : bottom_holder_depth,
                    topY=(Lower_Holder_Hole_Width > 0 && Lower_Holder_Hole_Depth > 0) ? Lower_Holder_Hole_Width : bottom_holder_width,
                    z=z,
                    radius=lower_holder_hole_roundness
                  );
              }
            }
          }
        }
        // y loop
      }
    }
    // x loop
  }
}

/*
 * Creates front-facing slot cutouts for easier object removal
 * Generates optional slot across holder fronts
 */
module holder_front_cutout() {

  if (holder_front_slot_width > 0) {
    height = (Bottom_Thickness > 0 ? Holder_Height : max(holder_height, Strict_Holder_Height ? holder_height : pegboard_height)) + .2;
    //echo("cutout height:", height);
    if (holder_depth > 0 && holder_width > 0) {

      // --- HEIGHTS ---
      H1 = height;
      H2 = max(holder_height, pegboard_height) - height;

      cutoutDepth = (holder_total_depth) / 2 + .1;
      translate([-Offset_From_Pegboard, 0, 0]) {
        for (y = [0:Holder_Count_Deep - 1]) {
          is_even = (y % 2 == 0);
          spacing = holder_width + holder_spacing_x;
          rotate_holder() {
            for (x = [1:Holder_Count_Wide - (is_even || !Offset_Holder_Rows || Holder_Count_Wide == 1 ? 0 : 1)]) {
              total = (Holder_Count_Wide + (!is_even && Offset_Holder_Rows ? 0 : 1)) * spacing;
              offset = -total / 2;
              translateX = -( (y * holder_total_depth) + (cutoutDepth / 2) - Wall_Thickness);
              translateY = (offset + (x * spacing));
              translateZ = -(Step_Offset_Amount > 0 && y > 0 ? y * Step_Offset_Amount : 0) + Bottom_Thickness / 2;
              // ---------------------------
              // MAIN HOLDER BLOCK
              // ---------------------------
              translate(
                [translateX, translateY, translateZ]
              ) {

                pColor("red")
                  tapered_rounded_box(
                    topX=cutoutDepth,
                    topY=holder_front_slot_width,
                    z=H1,
                    radius=0,
                    radiusCorners_mask=[1, 0, 0, 1]
                  );
              }

              // ---------------------------
              //   EXTENSION
              // ---------------------------
              if ( ( (Lower_Holder_Hole_Width > 0 && Lower_Holder_Hole_Depth > 0) || Bottom_Thickness == 0) ) {
                z = Bottom_Thickness + 1;
                translateZ2 = -( (y * Step_Offset_Amount) + holder_height / 2 - z / 2 + .5);

                translate(
                  [translateX, translateY, translateZ2]
                ) {

                  pColor("orange")
                    tapered_rounded_box(
                      topX=cutoutDepth,
                      topY=holder_front_slot_width,
                      z=z,
                      radius=0,
                      radiusCorners_mask=[1, 0, 0, 1]
                    );
                }
              }
            }
          }
          // y loop
        }
      }
      // x loop
    }
  }
}

/*
 * Helper - rotates geometry around arbitrary point
 * @param a Rotation angles [x, y, z]
 * @param pt [x, y, z] point to rotate around
 */
module rotate_about_pt(a, pt) {
  translate(pt) {
    rotate(a) {
      translate(-pt) {
        children();
      }
    }
  }
}

/*
 * Applies holder angle and positioning transformations
 * Handles angled and stepped holder rows
 */
module rotate_holder() {

  if (holder_angle < 0) {
    translate([-holder_total_depth, 0, -(holder_height)]) {
      rotate_about_pt([0, holder_angle, 0], [holder_total_depth, 0, 0]) {

        translate([holder_total_depth / 2, 0, (holder_height / 2)]) {
          children();
        }
      }
    }
  } else {
    translate([-holder_total_depth, 0, -holder_height]) {
      // rotate([0, holder_angle, 0])
      rotate_about_pt([0, holder_angle, 0], [holder_total_depth, 0, holder_height])
        translate([holder_total_depth / 2, 0, (holder_height / 2)]) {
          children();
        }
    }
  }
}

/*
 * Top-level assembly combining all holder structures
 * Creates the final pegboard mount with holders and mounting pins
 */
module finalHolder() {

if (Full_Array_Of_Pins){
  pinboard();
}

  difference() {
    holder_row_container();
    holder_holes();
    holder_front_cutout();
  }
}

/*
 * Main entry point for PegSmith - Advanced Pegboard Wizard
 * Renders complete pegboard system with specified holders and mounting hardware
 */
module pegSmith() {
  fColor("#4D64CF")
    rotate([0, 0, 0]) {
      finalHolder();
      pinboard_clips();
    }
  echo("PegSmith - Advanced Pegboard Wizard");
  echo("Written By Chad Urvig, January 2026");
}

pegSmith();
