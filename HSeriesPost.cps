/**
  Copyright (C) 2012-2017 by Autodesk, Inc.
  All rights reserved.

Diabase mods for Hermes
reworked 5-2-2018
*/

description = "Diabase";
vendor = "Diabase Engineering";
vendorUrl = "https://www.diabasepe.com";
legal = "Copyright (C) 2012-2017 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 24000;

longDescription = "Post for Hermes printer. By default positioning moves will be output as high feed G1s instead of G0s. You can turn on the property 'useG0' to force G0s but be careful as the CNC will follow a dogleg path rather than a direct path.";

extension = "gcode";
programNameIsInteger = false;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.01, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(355);
allowHelicalMoves = true;
// RW Diabase
//allowedCircularPlanes = undefined; // allow any circular motion
allowedCircularPlanes = (1 << PLANE_XY); // set to 1 to enable circular motion on X-Y only
allowSpiralMoves = true;
highFeedrate = (unit == IN) ? 500 : 5000;



// user-defined properties
properties = {
  writeWarning: true,   //write warning before start
  writeMachine: false, // write machine
  writeTools: true, // writes the tools
  writeVersion: false, // include version info
  preloadTool: false, // preloads next tool on tool change if any
  chipTransport: false, // turn on chip transport at start of program
  showSequenceNumbers: false, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 5, // increment for sequence numbers
  sequenceNumberOnlyOnToolChange: false, // only output sequence numbers on tool change
  optionalStop: false, // optional stop
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: false, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: false, // specifies that operation notes should be output
  useG0: false, // allow G0 when moving along more than one axis
  useG28: false, // specifies that G28 should be used instead of G53
  useSubroutines: false, // specifies that subroutines should be generated
  useSubroutinePatterns: false, // generates subroutines for patterned operation
  useSubroutineCycles: false, // generates subroutines for cycle operations on same holes
  useG187: false, // use G187 to set smoothing on the machine
  homePositionCenter: true, // moves the part in X in center of the door at end of program (ONLY WORKS IF THE TABLE IS MOVING)
  optionallyCycleToolsAtStart: false, // cycle through each tool used at the beginning of the program when block delete is turned off - this allows the operator to easily measure all tools before they are used for the first run of the program
  optionallyMeasureToolsAtStart: false, // measure each tool used at the beginning of the program when block delete is turned off - this allows the operator to easily measure all tools before they are used for the first run of the program
  makeAAxisOtherWay: false, // make the A-axis rotate the opposite way
  toolBreakageTolerance: 0.1, // value for which tool break detection will raise an alarm
  safeStartAllOperations: false, // write optional blocks at the beginning of all operations that include all commands to start program
  fastToolChange: false, // skip spindle off, coolant off, and Z retract to make tool change quicker
  useG95forTapping: false, // use IPR/MPR instead of IPM/MPM for tapping
  useG73Retract: false // use G73 Q K format for accumulated depth support
};

propertyDefinitions = {
  writeWarning: {title:"Write warning", description:"Adds warning interaction before start",group:0, type:"boolean"},//RW
  writeMachine: {title:"Write machine", description:"Output the machine settings in the header of the code.", group:0, type:"boolean"},
  writeTools: {title:"Write tool list", description:"Output a tool list in the header of the code.", group:0, type:"boolean"},
  writeVersion: {title:"Write version", description:"Write the version number in the header of the code.", group:0, type:"boolean"},
  preloadTool: {title:"Preload tool", description:"Preloads the next tool at a tool change (if any).", type:"boolean"},
  chipTransport: {title:"Use chip transport", description:"Enable to turn on chip transport at start of program.", type:"boolean"},
  showSequenceNumbers: {title:"Use sequence numbers", description:"Use sequence numbers for each block of outputted code.", group:1, type:"boolean"},
  sequenceNumberStart: {title:"Start sequence number", description:"The number at which to start the sequence numbers.", group:1, type:"integer"},
  sequenceNumberIncrement: {title:"Sequence number increment", description:"The amount by which the sequence number is incremented by in each block.", group:1, type:"integer"},
  sequenceNumberOnlyOnToolChange: {title:"Block number only on tool change", description:"Specifies that block numbers should only be output at tool changes.", type:"boolean"},
  optionalStop: {title:"Optional stop", description:"Specifies that optional stops M1 should be output at tool changes.", type:"boolean"},
  separateWordsWithSpace: {title:"Separate words with space", description:"Adds spaces between words if 'yes' is selected.", type:"boolean"},
  useRadius: {title:"Radius arcs", description:"If yes is selected, arcs are output using radius values rather than IJK.", type:"boolean"},
  useParametricFeed:  {title:"Parametric feed", description:"Parametric feed values based on movement type are output.", type:"boolean"},
  showNotes: {title:"Show notes", description:"Enable to output notes for operations.", type:"boolean"},
  useG0: {title:"Use G0", description:"Specifies that G0s should be used for rapid moves when moving along a single axis.", type:"boolean"},
  useG28: {title:"Use G28 instead of G53", description:"Specifies that machine retracts should be done using G28 instead of G53.", type:"boolean"},
  useSubroutines: {title:"Use subroutines", description:"Enables output of subroutines for each operation.", type:"boolean"},
  useSubroutinePatterns: {title:"Subroutines for patterns", description:"Enable output of subroutines for patterns.", type:"boolean"},
  useSubroutineCycles: {title:"Subroutines for cycles", description:"Enable output of subroutines for cycles.", type:"boolean"},
  useG187: {title:"Use G187", description:"Specifies that smoothing using G187 should be used.", type:"boolean"},
  homePositionCenter: {title:"Home position center", description:"Enable to center the part along X at the end of program for easy access. Requires a CNC with a moving table.", type:"boolean"},
  optionallyCycleToolsAtStart: {title:"Optionally cycle tools at start", description:"Cycle through each tool used at the beginning of the program when block delete is turned off.", type:"boolean"},
  optionallyMeasureToolsAtStart: {title:"Optionally measure tools at start", description:"Measure each tool used at the beginning of the program when block delete is turned off.", type:"boolean"},
  makeAAxisOtherWay: {title:"Rotate A-axis the opposite direction", description:"Use the left hand rule for the A-axis output.", type:"spatial"},
  toolBreakageTolerance: {title:"Tool breakage tolerance", description:"Specifies the tolerance for which tool break detection will raise an alarm.", type:"spatial"},
  safeStartAllOperations: {title:"Safe start all operations", description:"Write optional blocks at the beginning of all operations that include all commands to start program.", type:"spatial"},
  fastToolChange: {title:"Fast tool change", description:"Skip spindle off, coolant off, and Z retract to make tool change quicker.", type:"boolean"},
  useG95forTapping: {title:"Use G95 for tapping", description:"use IPR/MPR instead of IPM/MPM for tapping", type:"boolean"},
  useG73Retract: {title:"G73 cycles include accumulated depth", description:"Use G73 Q K format for accumulated depth support.", type:"boolean"}
};



// old machines only support 4 digits
var oFormat = createFormat({width:5, zeropad:true, decimals:0});

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var hFormat = createFormat({prefix:"H", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0});
var probe154Format = createFormat({decimals:0, zeropad:true, width:2});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = xyzFormat; // radius
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3), forceDecimal:true});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-1000
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var zOutput = createVariable({prefix:"Z"}, xyzFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, abcFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var inverseTimeOutput = createVariable({prefix:"F", force:true}, feedFormat);
var pitchOutput = createVariable({prefix:"F", force:true}, pitchFormat);
// RW Diabase var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var dOutput = createVariable({}, dFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I", force:true}, xyzFormat);
var jOutput = createReferenceVariable({prefix:"J", force:true}, xyzFormat);
var kOutput = createReferenceVariable({prefix:"K", force:true}, xyzFormat);


var gMotionModal = createModal({force:true}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G93-94
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({force:true}, gFormat); // modal group 10 // G98-99
var gRotationModal = createModal({}, gFormat); // modal group 16 // G68-G69

// fixed settings
var firstFeedParameter = 100; // the first variable to use with parametric feed
var forceResetWorkPlane = false; // enable to force reset of machine ABC on new orientation
var minimumCyclePoints = 5; // minimum number of points in cycle operation to consider for subprogram

var WARNING_WORK_OFFSET = 0;

var ANGLE_PROBE_NOT_SUPPORTED = 0;
var ANGLE_PROBE_USE_ROTATION = 1;
var ANGLE_PROBE_USE_CAXIS = 2;

var SUB_UNKNOWN = 0;
var SUB_PATTERN = 1;
var SUB_CYCLE = 2;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var maximumCircularRadiiDifference = toPreciseUnit(0.005, MM);
var maximumLineLength = 80; // the maximum number of charaters allowed in a line
var g68RotationMode = 0;
var angularProbingMode;
var subprograms = [];
var currentPattern = -1;
var firstPattern = false;
var currentSubprogram;
var lastSubprogram;
var definedPatterns = new Array();
var incrementalMode = false;
var saveShowSequenceNumbers;
var cycleSubprogramIsActive = false;
var patternIsActive = false;
var lastOperationComment = "";

// used to convert blocks to optional for safeStartAllOperations, might get used outside of onSection
var operationNeedsSafeStart = false;
var operationNeedsSafeToolCall = false;
var operationNeedsSafeWorkOffset = false;
var operationNeedsSafeWorkPlane = false;
var operationNeedsSafeCoolant = false;


/**
  Writes the specified block.
*/
function writeBlock() {
  if (properties.showSequenceNumbers && !properties.sequenceNumberOnlyOnToolChange) {
    if (sequenceNumber > 99999) {
     sequenceNumber = properties.sequenceNumberStart;
    }
    if (optionalSection) {
      var text = formatWords(arguments);
      if (text) {
        writeWords("/", "N" + sequenceNumber, text);
      }
    } else {
      writeWords2("N" + sequenceNumber, arguments);
    }
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    if (optionalSection) {
      writeWords2("/", arguments);
    } else {
      writeWords(arguments);
    }
  }
}

/**
  Writes the specified block - used for tool changes only.
*/
function writeToolBlock() {
  if (properties.showSequenceNumbers) {
    if (sequenceNumber > 99999) {
      sequenceNumber = properties.sequenceNumberStart;
    }
    writeWords2("N" + sequenceNumber, arguments);
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    writeWords(arguments);
  }
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  if (properties.showSequenceNumbers) {
    var words = formatWords(arguments);
    if (words) {
      writeWords("/", "N" + sequenceNumber, words);
      sequenceNumber += properties.sequenceNumberIncrement;
    }
  } else {
    writeWords2("/", arguments);
  }
}
//RW
function formatComment(text) {
  return ";" + String(text).replace(/[\(\)]/g, "");
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text.substr(0, maximumLineLength - 2)));
}

/**
  Returns the matching HAAS tool type for the tool.
*/
function getHaasToolType(toolType) {
  switch (toolType) {
  case TOOL_DRILL:
  case TOOL_REAMER:
    return 1; // drill
  case TOOL_TAP_RIGHT_HAND:
  case TOOL_TAP_LEFT_HAND:
    return 2; // tap
  case TOOL_MILLING_FACE:
  case TOOL_MILLING_SLOT:
  case TOOL_BORING_BAR:
    return 3; // shell mill
  case TOOL_MILLING_END_FLAT:
  case TOOL_MILLING_END_BULLNOSE:
  case TOOL_MILLING_TAPERED:
  case TOOL_MILLING_DOVETAIL:
    return 4; // end mill
  case TOOL_DRILL_SPOT:
  case TOOL_MILLING_CHAMFER:
  case TOOL_DRILL_CENTER:
  case TOOL_COUNTER_SINK:
  case TOOL_COUNTER_BORE:
  case TOOL_MILLING_THREAD:
  case TOOL_MILLING_FORM:
    return 5; // center drill
  case TOOL_MILLING_END_BALL:
  case TOOL_MILLING_LOLLIPOP:
    return 6; // ball nose
  case TOOL_PROBE:
    return 7; // probe
  default:
    error(localize("Invalid HAAS tool type."));
    return -1;
  }
}

function getHaasProbingType(toolType, use9023) {
  switch (getHaasToolType(toolType)) {
  case 3:
  case 4:
    return (use9023 ? 23 : 1); // rotate
  case 1:
  case 2:
  case 5:
  case 6:
  case 7:
    return (use9023 ? 12 : 2); // non rotate
  case 0:
    return (use9023 ? 13 : 3); // rotate length and dia
  default:
    error(localize("Invalid HAAS tool type."));
    return -1;
  }
}

function writeToolCycleBlock(tool) {
  writeOptionalBlock("T" + toolFormat.format(tool.number), mFormat.format(6)); // get tool
  writeOptionalBlock(mFormat.format(0)); // wait for operator
}

function writeToolMeasureBlock(tool) {
  if (true) { // use Macro P9023 to measure tools
    var probingType = getHaasProbingType(tool.type, true);
    writeOptionalBlock(
      gFormat.format(65),
      "P9023",
      "A" + probingType + ".",
      "T" + toolFormat.format(tool.number),
      conditional((probingType != 12), "H" + xyzFormat.format(tool.bodyLength + tool.holderLength)),
      conditional((probingType != 12), "D" + xyzFormat.format(tool.diameter))
    );
  } else { // use Macro P9995 to measure tools
    writeOptionalBlock("T" + toolFormat.format(tool.number), mFormat.format(6)); // get tool
    writeOptionalBlock(
      gFormat.format(65),
      "P9995",
      "A0.",
      "B" + getHaasToolType(tool.type) + ".",
      "C" + getHaasProbingType(tool.type, false) + ".",
      "T" + toolFormat.format(tool.number),
      "E" + xyzFormat.format(tool.bodyLength + tool.holderLength),
      "D" + xyzFormat.format(tool.diameter),
      "K" + xyzFormat.format(0.1),
      "I0."
    ); // probe tool
  }
}
function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  gRotationModal.format(69); // Default to G69 Rotation Off

  if (true) {
    var aAxis = createAxis({coordinate:0, table:true, axis:[(properties.makeAAxisOtherWay ? -1 : 1) * 1, 0, 0], cyclic:true, preference:0});
	var cAxis = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:true, range:[-13320, 13320], preference:1});
    machineConfiguration = new MachineConfiguration(aAxis,cAxis);

    setMachineConfiguration(machineConfiguration);
    optimizeMachineAngles2(1); // map tip mode
  }

  if (!machineConfiguration.isMachineCoordinate(0)) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1)) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2)) {
    cOutput.disable();
  }

  if (highFeedrate <= 0) {
    error(localize("You must set 'highFeedrate' because axes are not synchronized for rapid traversal."));
    return;
  }
  
  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }
  
 //RW
if (programName) {
    var programId = programName;
    if (programComment) {
        writeln(formatComment(programId + " " +programComment));
    } else {
        writeln(formatComment(programId));
    }
} else {
    error(localize("Program name has not been specified."));
    return;
}

  sequenceNumber = properties.sequenceNumberStart;



  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (properties.writeMachine && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": "  + description);
    }
  }

  // dump tool information
  if (properties.writeTools) {
  writeComment("tool table");
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var comment = "T" + toolFormat.format(tool.number) + " " +
          "D=" + xyzFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + xyzFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
    }
  }

// RW Diabase optional are you sure warning
//RW Diabase writeln("%");   
 writeln("M42 P5 S0"); 
 if (properties.writeWarning)  // allow user to set in fusion
	 writeln("M291 P\"Starting machining now. No additional homing will be done. Make sure coordinates are set.\" R\"Crash Check\" S3");   
  
  if (properties.writeVersion) {
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate());
    }
  }



  // optionally cycle through all tools
  if (properties.optionallyCycleToolsAtStart || properties.optionallyMeasureToolsAtStart) {
    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      writeln("");

      writeOptionalBlock(mFormat.format(0), formatComment(localize("Read note"))); // wait for operator
      writeComment(localize("With BLOCK DELETE turned off each tool will cycle through"));
      writeComment(localize("the spindle to verify that the correct tool is in the tool magazine"));
      if (properties.optionallyMeasureToolsAtStart) {
        writeComment(localize("and to automatically measure it"));
      }
      writeComment(localize("Once the tools are verified turn BLOCK DELETE on to skip verification"));
      
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        if (properties.optionallyMeasureToolsAtStart && (tool.type == TOOL_PROBE)) {
          continue;
        }
        var comment = "T" + toolFormat.format(tool.number) + " " +
          "D=" + xyzFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
        if (properties.optionallyMeasureToolsAtStart) {
          writeToolMeasureBlock(tool);
        } else {
          writeToolCycleBlock(tool);
        }
      }
    }
    writeln("");
  }

  if (false /*properties.useDynamicWorkOffset*/) {
    var failed = false;
    var dynamicWCSs = {};
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var section = getSection(i);
      var description = section.hasParameter("operation-comment") ? section.getParameter("operation-comment") : ("#" + (i + 1));
      if (!section.hasDynamicWorkOffset()) {
        error(subst(localize("Dynamic work offset has not been set for operation '%1'."), description));
        failed = true;
      }
      
      var o = section.getDynamicWCSOrigin();
      var p = section.getDynamicWCSPlane();
      if (dynamicWCSs[section.getDynamicWorkOffset()]) {
        if ((Vector.diff(o, dynamicWCSs[section.getDynamicWorkOffset()].origin).length > 1e-9) ||
            (Matrix.diff(p, dynamicWCSs[section.getDynamicWorkOffset()].plane).n1 > 1e-9)) {
          error(subst(localize("Dynamic WCS mismatch for operation '%1'."), description));
          failed = true;
        }
      } else {
        dynamicWCSs[section.getDynamicWorkOffset()] = {origin:o, plane:p};
      }
    }
    if (failed) {
      return;
    }
  }

  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (xyzFormat.areDifferent(tooli.diameter, toolj.diameter) ||
              xyzFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
              abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
              (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  // absolute coordinates and feed per min
 // writeBlock(gAbsIncModal.format(90), gFeedModeModal.format(94), gPlaneModal.format(17));
  // RW Diabase
   writeBlock(gAbsIncModal.format(90));
   
   
  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(20));
    break;
  case MM:
    writeBlock(gUnitModal.format(21));
    break;
  }

  if (properties.chipTransport) {
    onCommand(COMMAND_START_CHIP_TRANSPORT);
  }
     //RW Dibase writeBlock("; end of open");
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function writeG187() {
  if (hasParameter("operation-strategy") && (getParameter("operation-strategy") == "drill")) {
    writeBlock(gFormat.format(187)); // reset G187 setting to machine default
  } else if (hasParameter("operation:tolerance")) {
    var tolerance = Math.max(getParameter("operation:tolerance"), 0);
    if (tolerance > 0) {
      var stockToLeaveThreshold = toUnit(0.1, MM);
      var stockToLeave = 0;
      var verticalStockToLeave = 0;
      if (hasParameter("operation:stockToLeave")) {
        stockToLeave = xyzFormat.getResultingValue(getParameter("operation:stockToLeave"));
      }
      if (hasParameter("operation:verticalStockToLeave")) {
        verticalStockToLeave = xyzFormat.getResultingValue(getParameter("operation:verticalStockToLeave"));
      }

      var workMode;
      if ((stockToLeave > stockToLeaveThreshold) && (verticalStockToLeave > stockToLeaveThreshold)) {
        workMode = 1; // roughing
      } else {
        if ((stockToLeave != 0) || (verticalStockToLeave != 0)) {
          workMode = 2; // default
        } else {
          workMode = 3; // fine
        }
      }
      writeBlock(gFormat.format(187), "P" + workMode); // set tolerance mode
    } else {
      writeBlock(gFormat.format(187)); // reset G187 setting to machine default
    }
  } else {
    writeBlock(gFormat.format(187)); // reset G187 setting to machine default
  }
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return "F#" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  
  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }
  
  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }
  
  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), Math.max(getParameter("operation:tool_feedCutting"), getParameter("operation:tool_feedEntry"), getParameter("operation:tool_feedExit")));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }
  
  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if (movements & (1 << MOVEMENT_HIGH_FEED)) {
      var feedContext = new FeedContext(id, localize("High Feed"), this.highFeedrate);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
    }
    ++id;
  }
  
  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("#" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function defineWorkPlane(_section, _setWorkPlane) {
  var abc = new Vector(0, 0, 0);
  if (machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    // set working plane after datum shift

    if (_section.isMultiAxis()) {
      cancelTransformation();
      abc = _section.getInitialToolAxisABC();
      if (_setWorkPlane) {
        forceWorkPlane();
        // RW Diabase onCommand(COMMAND_UNLOCK_MULTI_AXIS);
        gMotionModal.reset();
        writeBlock(
          gMotionModal.format(0),
          conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
          conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
          conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
        );
      }
    } else {
      abc = getWorkPlaneMachineABC(_section.workPlane);
      if (_setWorkPlane) {
        setWorkPlane(abc);
      }
    }
  } else { // pure 3D
    var remaining = _section.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return abc;
    }
    setRotation(remaining);
  }
  return abc;
}

function setWorkPlane(abc) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  // RW Diabase onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  gMotionModal.reset();
  writeBlock(
    operationNeedsSafeWorkPlane ? "/" : "",
    gMotionModal.format(0),
    conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
  );
  
  onCommand(COMMAND_LOCK_MULTI_AXIS);

  currentWorkPlaneABC = abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(workPlane) {
  var W = workPlane; // map to global frame

  var abc = machineConfiguration.getABC(W);
  if (closestABC) {
    if (currentMachineABC) {
      abc = machineConfiguration.remapToABC(abc, currentMachineABC);
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  } else {
    abc = machineConfiguration.getPreferredABC(abc);
  }
  
  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }
  
  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }
  
  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var tcp = false;
  if (tcp) {
    setRotation(W); // TCP mode
  } else {
    var O = machineConfiguration.getOrientation(abc);
    var R = machineConfiguration.getRemainingOrientation(abc, W);
    setRotation(R);
  }
  
  return abc;
}

function isProbeOperation() {
  return (hasParameter("operation-strategy") && getParameter("operation-strategy") == "probe");
}

var probeOutputWorkOffset = 1;

function onParameter(name, value) {
  if (name == "probe-output-work-offset") {
    probeOutputWorkOffset = (value > 0) ? value : 1;
  }
}

/** Returns true if the spatial vectors are significantly different. */
function areSpatialVectorsDifferent(_vector1, _vector2) {
  return (xyzFormat.getResultingValue(_vector1.x) != xyzFormat.getResultingValue(_vector2.x)) ||
    (xyzFormat.getResultingValue(_vector1.y) != xyzFormat.getResultingValue(_vector2.y)) ||
    (xyzFormat.getResultingValue(_vector1.z) != xyzFormat.getResultingValue(_vector2.z));
}

/** Returns true if the spatial boxes are a pure translation. */
function areSpatialBoxesTranslated(_box1, _box2) {
  return !areSpatialVectorsDifferent(Vector.diff(_box1[1], _box1[0]), Vector.diff(_box2[1], _box2[0])) &&
    !areSpatialVectorsDifferent(Vector.diff(_box2[0], _box1[0]), Vector.diff(_box2[1], _box1[1]));
}

function subprogramDefine(_initialPosition, _abc, _retracted, _zIsOutput) {
  // convert patterns into subprograms
  var usePattern = false;
  patternIsActive = false;
  if (currentSection.isPatterned && currentSection.isPatterned() && properties.useSubroutinePatterns) {
    currentPattern = currentSection.getPatternId();
    firstPattern = true;
    for (var i = 0; i < definedPatterns.length; ++i) {
      if ((definedPatterns[i].patternType == SUB_PATTERN) && (currentPattern == definedPatterns[i].patternId)) {
        currentSubprogram = definedPatterns[i].subProgram;
        usePattern = definedPatterns[i].validPattern;
        firstPattern = false;
        break;
      }
    }

    if (firstPattern) {
      // determine if this is a valid pattern for creating a subprogram
      usePattern = subprogramIsValid(currentSection, currentPattern, SUB_PATTERN);
      if (usePattern) {
        currentSubprogram = ++lastSubprogram;
      }
      definedPatterns.push({
        patternType: SUB_PATTERN,
        patternId: currentPattern,
        subProgram: currentSubprogram,
        validPattern: usePattern,
        initialPosition: _initialPosition,
        finalPosition: _initialPosition
      });
    }

    if (usePattern) {
      // make sure Z-position is output prior to subprogram call
      if (!_retracted && !_zIsOutput) {
        writeBlock(gMotionModal.format(0), zOutput.format(_initialPosition.z));
      }

      // call subprogram
      writeBlock(mFormat.format(98), "P" + oFormat.format(currentSubprogram));
      patternIsActive = true;

      if (firstPattern) {
        subprogramStart(_initialPosition, _abc, true);
      } else {
        skipRemainingSection();
        setCurrentPosition(getFramePosition(currentSection.getFinalPosition()));
      }
    }
  }

  // Output cycle operation as subprogram
  if (!usePattern && properties.useSubroutineCycles && currentSection.doesStrictCycle &&
      (currentSection.getNumberOfCycles() == 1) && currentSection.getNumberOfCyclePoints() >= minimumCyclePoints) {
    var finalPosition = getFramePosition(currentSection.getFinalPosition());
    currentPattern = currentSection.getNumberOfCyclePoints();
    firstPattern = true;
    for (var i = 0; i < definedPatterns.length; ++i) {
      if ((definedPatterns[i].patternType == SUB_CYCLE) && (currentPattern == definedPatterns[i].patternId) &&
          !areSpatialVectorsDifferent(_initialPosition, definedPatterns[i].initialPosition) &&
          !areSpatialVectorsDifferent(finalPosition, definedPatterns[i].finalPosition)) {
        currentSubprogram = definedPatterns[i].subProgram;
        usePattern = definedPatterns[i].validPattern;
        firstPattern = false;
        break;
      }
    }

    if (firstPattern) {
      // determine if this is a valid pattern for creating a subprogram
      usePattern = subprogramIsValid(currentSection, currentPattern, SUB_CYCLE);
      if (usePattern) {
        currentSubprogram = ++lastSubprogram;
      }
      definedPatterns.push({
        patternType: SUB_CYCLE,
        patternId: currentPattern,
        subProgram: currentSubprogram,
        validPattern: usePattern,
        initialPosition: _initialPosition,
        finalPosition: finalPosition
      });
    }
    cycleSubprogramIsActive = usePattern;
  }

  // Output each operation as a subprogram
  if (!usePattern && properties.useSubroutines) {
    currentSubprogram = ++lastSubprogram;
    writeBlock(mFormat.format(98), "P" + oFormat.format(currentSubprogram));
    firstPattern = true;
    subprogramStart(_initialPosition, _abc, false);
  }
}

function subprogramStart(_initialPosition, _abc, _incremental) {
  redirectToBuffer();
  var comment = "";
  if (hasParameter("operation-comment")) {
    comment = getParameter("operation-comment");
  }
  writeln(
    "O" + oFormat.format(currentSubprogram) +
    conditional(comment, formatComment(comment.substr(0, maximumLineLength - 2 - 6 - 1)))
  );
  saveShowSequenceNumbers = properties.showSequenceNumbers;
  properties.showSequenceNumbers = false;
  if (_incremental) {
    setIncrementalMode(_initialPosition, _abc);
  }
}

function subprogramEnd() {
  if (firstPattern) {
    writeBlock(mFormat.format(99));
    writeln("");
    subprograms += getRedirectionBuffer();
  }
  forceAny();
  firstPattern = false;
  properties.showSequenceNumbers = saveShowSequenceNumbers;
  closeRedirection();
}

function subprogramIsValid(_section, _patternId, _patternType) {
  var sectionId = _section.getId();
  var numberOfSections = getNumberOfSections();
  var validSubprogram = _patternType != SUB_CYCLE;

  var masterPosition = new Array();
  masterPosition[0] = getFramePosition(_section.getInitialPosition());
  masterPosition[1] = getFramePosition(_section.getFinalPosition());
  var tempBox = _section.getBoundingBox();
  var masterBox = new Array();
  masterBox[0] = getFramePosition(tempBox[0]);
  masterBox[1] = getFramePosition(tempBox[1]);

  var rotation = getRotation();
  var translation = getTranslation();

  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getId() != sectionId) {
      defineWorkPlane(section, false);
      // check for valid pattern
      if (_patternType == SUB_PATTERN) {
        if (section.getPatternId() == _patternId) {
          var patternPosition = new Array();
          patternPosition[0] = getFramePosition(section.getInitialPosition());
          patternPosition[1] = getFramePosition(section.getFinalPosition());
          tempBox = section.getBoundingBox();
          var patternBox = new Array();
          patternBox[0] = getFramePosition(tempBox[0]);
          patternBox[1] = getFramePosition(tempBox[1]);

          if (!areSpatialBoxesTranslated(masterPosition, patternPosition) || !areSpatialBoxesTranslated(masterBox, patternBox)) {
            validSubprogram = false;
            break;
          }
        }

      // check for valid cycle operation
      } else if (_patternType == SUB_CYCLE) {
        if ((section.getNumberOfCyclePoints() == _patternId) && (section.getNumberOfCycles() == 1)) {
          var patternInitial = getFramePosition(section.getInitialPosition());
          var patternFinal = getFramePosition(section.getFinalPosition());
          if (!areSpatialVectorsDifferent(patternInitial, masterPosition[0]) && !areSpatialVectorsDifferent(patternFinal, masterPosition[1])) {
            validSubprogram = true;
            break;
          }
        }
      }
    }
  }
  setRotation(rotation);
  setTranslation(translation);
  return(validSubprogram);
}

function setIncrementalMode(xyz, abc) {
  xOutput = createIncrementalVariable({prefix:"X"}, xyzFormat);
  xOutput.format(xyz.x);
  xOutput.format(xyz.x);
  yOutput = createIncrementalVariable({prefix:"Y"}, xyzFormat);
  yOutput.format(xyz.y);
  yOutput.format(xyz.y);
  zOutput = createIncrementalVariable({prefix:"Z"}, xyzFormat);
  zOutput.format(xyz.z);
  zOutput.format(xyz.z);
  aOutput = createIncrementalVariable({prefix:"W"}, abcFormat);
  aOutput.format(abc.x);
  aOutput.format(abc.x);
  bOutput = createIncrementalVariable({prefix:"A"}, abcFormat);
  bOutput.format(abc.y);
  bOutput.format(abc.y);
  cOutput = createIncrementalVariable({prefix:"A"}, abcFormat);
  cOutput.format(abc.z);
  cOutput.format(abc.z);
  gAbsIncModal.reset();
  writeBlock(gAbsIncModal.format(91));
  incrementalMode = true;
}

function setAbsoluteMode(xyz, abc) {
  if (incrementalMode) {
    xOutput = createVariable({prefix:"X"}, xyzFormat);
    xOutput.format(xyz.x);
    yOutput = createVariable({prefix:"Y"}, xyzFormat);
    yOutput.format(xyz.y);
    zOutput = createVariable({prefix:"Z"}, xyzFormat);
    zOutput.format(xyz.z);
    aOutput = createVariable({prefix:"W"}, abcFormat);
    aOutput.format(abc.x);
    bOutput = createVariable({prefix:"A"}, abcFormat);
    bOutput.format(abc.y);
    cOutput = createVariable({prefix:"A"}, abcFormat);
    cOutput.format(abc.z);
    gAbsIncModal.reset();
    writeBlock(gAbsIncModal.format(90));
    incrementalMode = false;
  }
}

function onSection() {
  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();

  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);
  
  var retracted = false; // specifies that the tool has been retracted to the safe plane
  var zIsOutput = false; // true if the Z-position has been output, used for patterns

  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis());

  if (properties.safeStartAllOperations && !isFirstSection()) { // determine what needs to be included in safe start
    if (!insertToolCall) { // tool call required
      operationNeedsSafeToolCall = true;
      forceSpindleSpeed = true;
    }
    if (!newWorkOffset) { // offset required
      operationNeedsSafeWorkOffset = true;
    }
    if (!newWorkPlane) { // workplane required
      operationNeedsSafeWorkPlane = true;
    }
    operationNeedsSafeStart = true; // operation will contain safe start components
  }

  if ((insertToolCall && !properties.fastToolChange) || newWorkOffset || newWorkPlane || toolChecked) {
    
    // stop spindle before retract during tool change
    if (insertToolCall && !isFirstSection() && !toolChecked && !properties.fastToolChange) {
      onCommand(COMMAND_STOP_SPINDLE);
	  //writeBlock(mFormat.format(tool.clockwise ? 3 : 4),"P",toolFormat.format(tool.number),"S0"); //has new tool number at this point
    }
    
    // retract to safe plane
    retracted = true;
    if (properties.useG28) {
      writeBlock(gFormat.format(28), gAbsIncModal.format(91), "Z" + xyzFormat.format(0));
    } else {
      gMotionModal.reset();
      // RW Diabase writeBlock(gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), "Z" +xyzFormat.format(0));
    }
    writeBlock(gAbsIncModal.format(90));
    zOutput.reset();

    if (forceResetWorkPlane && newWorkPlane) {
      forceWorkPlane();
      setWorkPlane(new Vector(0, 0, 0)); // reset working plane
    }
  }

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment && ((comment !== lastOperationComment) || !patternIsActive || insertToolCall)) {
      writeln("");
      writeComment(comment);
      lastOperationComment = comment;
    } else if (!patternIsActive || insertToolCall) {
      writeln("");
    }
  } else {
    writeln("");
  }
  
  if (operationNeedsSafeStart && !retracted) { // retract before safestart operations
    retracted = true;
    if (properties.useG28) {
      writeBlock("/", gFormat.format(28), gAbsIncModal.format(91), "Z" + xyzFormat.format(0));
    } else {
      gMotionModal.reset();
      writeBlock("/", gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), "Z" + xyzFormat.format(0));
    }
    writeBlock(gAbsIncModal.format(90));
    zOutput.reset();
  }
  
  if (properties.showNotes && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }
  
  if (insertToolCall || operationNeedsSafeStart) {
    forceWorkPlane();
    
    retracted = true;
    if (properties.fastToolChange && !isProbeOperation()) {
      currentCoolantMode = COOLANT_OFF;
    } else if (!operationNeedsSafeToolCall) { // no coolant off command if safe start operation
      onCommand(COMMAND_COOLANT_OFF);
    }
  
    if (!isFirstSection() && properties.optionalStop) {
      onCommand(COMMAND_OPTIONAL_STOP);
    }

    if (tool.number > 99) {
      warning(localize("Tool number exceeds maximum value."));
    }

    writeToolBlock(
      operationNeedsSafeToolCall ? "/" : "",
      "T" + toolFormat.format(tool.number)
//     , mFormat.format(6) // RW Diabase
    );

    if (tool.comment) {
      writeComment(tool.comment);
    }
    var showToolZMin = false;
    if (showToolZMin) {
      if (is3D()) {
        var numberOfSections = getNumberOfSections();
        var zRange = currentSection.getGlobalZRange();
        var number = tool.number;
        for (var i = currentSection.getId() + 1; i < numberOfSections; ++i) {
          var section = getSection(i);
          if (section.getTool().number != number) {
            break;
          }
          zRange.expandToRange(section.getGlobalZRange());
        }
        writeComment(localize("ZMIN") + "=" + xyzFormat.format(zRange.getMinimum()));
      }
    }
  }
  
  // activate those two coolant modes before the spindle is turned on
  if ((tool.coolant == COOLANT_THROUGH_TOOL) || (tool.coolant == COOLANT_AIR_THROUGH_TOOL) || (tool.coolant == COOLANT_FLOOD_THROUGH_TOOL)) {
    if (!isFirstSection() && !insertToolCall && (currentCoolantMode != tool.coolant)) {
      onCommand(COMMAND_STOP_SPINDLE);
      forceSpindleSpeed = true;
    }
    setCoolant(tool.coolant);
  } else if ((currentCoolantMode == COOLANT_THROUGH_TOOL) || (currentCoolantMode == COOLANT_AIR_THROUGH_TOOL) || (currentCoolantMode == COOLANT_FLOOD_THROUGH_TOOL)) {
    onCommand(COMMAND_STOP_SPINDLE);
    setCoolant(COOLANT_OFF);
    forceSpindleSpeed = true;
  }

  
  if (toolChecked) {
    forceSpindleSpeed = true; // spindle must be restarted if tool is checked without a tool change
    toolChecked = false; // state of tool is not known at the beginning of a section since it could be broken for the previous section
  }

  if (!isProbeOperation() &&
      (insertToolCall ||
       forceSpindleSpeed ||
       isFirstSection() ||
       (rpmFormat.areDifferent(tool.spindleRPM, sOutput.getCurrent())) ||
       (tool.clockwise != getPreviousSection().getTool().clockwise))) {
    forceSpindleSpeed = false;
    
    if (tool.spindleRPM < 1) {
      error(localize("Spindle speed out of range."));
      return;
    }
    if (tool.spindleRPM > 99999) {
      warning(localize("Spindle speed exceeds maximum value."));
    }
    writeBlock(mFormat.format(tool.clockwise ? 3 : 4),"P",toolFormat.format(tool.number - 1),
      sOutput.format(tool.spindleRPM)
    );	  
  }
  //      sOutput.format(tool.spindleRPM), mFormat.format(tool.clockwise ? 3 : 4),"HERE"
  if (properties.useParametricFeed &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") != "drill") &&
      !(currentSection.isMultiAxis()) && // legacy
      !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
        activeMovements &&
        (getCurrentSectionId() > 0) &&
        ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }

  // wcs
  if (insertToolCall || operationNeedsSafeWorkOffset) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = currentSection.workOffset;
  if (workOffset == 0) {
    warningOnce(localize("Work offset has not been specified. Using G54 as WCS."), WARNING_WORK_OFFSET);
    workOffset = 1;
  }
  if (workOffset > 0) {
    if (workOffset > 6) {
      var code = workOffset - 6;
      if (code > 99) {
        error(localize("Work offset out of range."));
        return;
      }
      if (workOffset != currentWorkOffset) {
        forceWorkPlane();
        writeBlock(gFormat.format(154), "P" + code);
        currentWorkOffset = workOffset;
      }
    } else {
      if (workOffset != currentWorkOffset) {
        forceWorkPlane();
        writeBlock(gFormat.format(53 + workOffset)); // G54->G59
        currentWorkOffset = workOffset;
      }
    }
  }

  forceXYZ();

  var abc = defineWorkPlane(currentSection, true);

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  forceAny();
  gMotionModal.reset();

  if (properties.useG187) {
    writeG187();
  }

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      zIsOutput = true;
    }
  }

  if (insertToolCall || retracted) {
    var lengthOffset = tool.lengthOffset;
    if (lengthOffset > 200) {
      error(localize("Length offset out of range."));
      return;
    }

    gMotionModal.reset();
    //writeBlock(gPlaneModal.format(17)); AR
    
    if (!machineConfiguration.isHeadConfiguration()) {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
      );
      /*writeBlock(
        gMotionModal.format(0),
        gFormat.format(43),
        zOutput.format(initialPosition.z),
        hFormat.format(lengthOffset)
      );*/
    } else {
      /*writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0),
        gFormat.format(43),
        xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y),
        zOutput.format(initialPosition.z),
        hFormat.format(lengthOffset)
      );*/
    }
    zIsOutput = true;

    gMotionModal.reset();
  } else {
    var x = xOutput.format(initialPosition.x);
    var y = yOutput.format(initialPosition.y);
    if (!properties.useG0 && x && y) {
      // axes are not synchronized
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(1), x, y, getFeed(highFeedrate));
    } else {
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(0), x, y);
    }
  }

  if (insertToolCall) {
    if (properties.preloadTool) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        writeBlock("T" + toolFormat.format(nextTool.number));
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if (tool.number != firstToolNumber) {
          writeBlock("T" + toolFormat.format(firstToolNumber));
        }
      }
    }
  }
  
  if (isProbeOperation()) {
    if (g68RotationMode != 0) {
      error(localize("You cannot probe while G68 Rotation is in effect."));
      return;
    }
    angularProbingMode = getAngularProbingMode();
    writeBlock(gFormat.format(65), "P" + 9832); // spin the probe on
  }

  // define subprogram
  subprogramDefine(initialPosition, abc, retracted, zIsOutput);
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  seconds = clamp(0.001, seconds, 99999.999);
  //writeBlock(gFeedModeModal.format(94), gFormat.format(4), "P" + milliFormat.format(seconds * 1000));
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
}

function onCycle() {
  //writeBlock(gPlaneModal.format(17));
}

function getCommonCycle(x, y, z, r, c) {
  forceXYZ(); // force xyz on first drill hole of any cycle
  if (incrementalMode) {
    zOutput.format(c);
    return [xOutput.format(x), yOutput.format(y),
      "Z" + xyzFormat.format(z - r),
      "R" + xyzFormat.format(r - c)];
  } else {
    return [xOutput.format(x), yOutput.format(y),
      zOutput.format(z),
      "R" + xyzFormat.format(r)];
  }
}

/** Convert approach to sign. */
function approach(value) {
  validate((value == "positive") || (value == "negative"), "Invalid approach.");
  return (value == "positive") ? 1 : -1;
}

/**
  Determine if angular probing is supported.
*/
function getAngularProbingMode() {
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineConfiguration.isMachineCoordinate(2)) {
      return(ANGLE_PROBE_USE_CAXIS);
    } else {
      return(ANGLE_PROBE_NOT_SUPPORTED);
    }
  } else {
    return(ANGLE_PROBE_USE_ROTATION);
  }
}

/**
  Output rotation offset based on angular probing cycle.
*/
function setProbingAngle() {
  if ((g68RotationMode == 1) || (g68RotationMode == 2)) { // Rotate coordinate system for Angle Probing
    if (angularProbingMode == ANGLE_PROBE_USE_ROTATION) {
      gRotationModal.reset();
      gAbsIncModal.reset();
      var xCode = (g68RotationMode == 1) ? "X0" : "X[#185]";
      var yCode = (g68RotationMode == 1) ? "Y0" : "Y[#186]";
      writeBlock(gRotationModal.format(68), gAbsIncModal.format(90), xCode, yCode, "R[#189]");
      g68RotationMode = 3;
    } else if (angularProbingMode == ANGLE_PROBE_USE_CAXIS) {
      var workOffset = probeOutputWorkOffset ? probeOutputWorkOffset : currentWorkOffset;
      if (workOffset > 6) {
        error(localize("Angle Probing only supports work offsets 1-6."));
        return;
      }
      var param = 5200 + workOffset * 20 + 5;
      writeBlock("#" + param + "=" + "#189");
      g68RotationMode = 0;
    } else {
      error(localize("Angular Probing is not supported for this machine configuration."));
      return;
    }
  }
}

function onCyclePoint(x, y, z) {
  var probeWorkOffsetCode;
  if (isProbeOperation()) {
    setCurrentPosition(new Vector(x, y, z));

    var workOffset = probeOutputWorkOffset ? probeOutputWorkOffset : currentWorkOffset;
    if (workOffset > 99) {
      error(localize("Work offset is out of range."));
      return;
    } else if (workOffset > 6) {
      probeWorkOffsetCode = "154." + probe154Format.format(workOffset - 6);
    } else {
      probeWorkOffsetCode = workOffset + "."; // G54->G59
    }
  }

  var forceCycle = false;
  switch (cycleType) {
  case "tapping-with-chip-breaking":
  case "left-tapping-with-chip-breaking":
  case "right-tapping-with-chip-breaking":
    forceCycle = true;
    if (!isFirstCyclePoint()) {
      writeBlock(gCycleModal.format(80));
      gMotionModal.reset();
    }
  }
  
  if (forceCycle || isFirstCyclePoint()) {
    repositionToCycleClearance(cycle, x, y, z);
    
    // return to initial Z which is clearance plane and set absolute mode

    var F = cycle.feedrate;
    var P = (cycle.dwell == 0) ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
    case "drilling":
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(81),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        feedOutput.format(F)
      );
      break;
    case "counter-boring":
      if (P > 0) {
        writeBlock(
          gRetractModal.format(98), gCycleModal.format(82),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          "P" + milliFormat.format(P), // not optional
          feedOutput.format(F)
        );
      } else {
        writeBlock(
          gRetractModal.format(98), gCycleModal.format(81),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          feedOutput.format(F)
        );
      }
      break;
    case "chip-breaking":
        expandCyclePoint(x, y, z);
      break;
    case "deep-drilling":
    //expandCyclePoint(x, y, z);
    
       writeBlock(
         gRetractModal.format(98), gCycleModal.format(83),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        (((cycle.incrementalDepthReduction > 0) ? "I" : "Q") + xyzFormat.format(cycle.incrementalDepth)),
        conditional(cycle.incrementalDepthReduction > 0, "J" + xyzFormat.format(cycle.incrementalDepthReduction)),
        conditional(cycle.incrementalDepthReduction > 0, "K" + xyzFormat.format(cycle.minimumIncrementalDepth)),
       conditional(P > 0, "P" + milliFormat.format(P)), // optional
         feedOutput.format(F)
      );
      break;
    case "tapping":
      F = (properties.useG95forTapping ? tool.getThreadPitch() : tool.getTappingFeedrate());
      if (properties.useG95forTapping) {
        writeBlock(gFeedModeModal.format(95));
      }
      writeBlock(
        gRetractModal.format(98), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND) ? 74 : 84),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        pitchOutput.format(F)
      );
      forceFeed();
      break;
    case "left-tapping":
      F = (properties.useG95forTapping ? tool.getThreadPitch() : tool.getTappingFeedrate());
      if (properties.useG95forTapping) {
        writeBlock(gFeedModeModal.format(95));
      }
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(74),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        pitchOutput.format(F)
      );
      forceFeed();
      break;
    case "right-tapping":
      F = (properties.useG95forTapping ? tool.getThreadPitch() : tool.getTappingFeedrate());
      if (properties.useG95forTapping) {
        writeBlock(gFeedModeModal.format(95));
      }
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(84),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        pitchOutput.format(F)
      );
      forceFeed();
      break;
    case "tapping-with-chip-breaking":
    case "left-tapping-with-chip-breaking":
    case "right-tapping-with-chip-breaking":
      F = (properties.useG95forTapping ? tool.getThreadPitch() : tool.getTappingFeedrate());
      if (properties.useG95forTapping) {
        writeBlock(gFeedModeModal.format(95));
      }
      // Parameter 57 bit 6, REPT RIG TAP, is set to 1 (On)
      // On Mill software versions12.09 and above, REPT RIG TAP has been moved from the Parameters to Setting 133
      var u = cycle.stock;
      var step = cycle.incrementalDepth;
      var first = true;
      while (u > cycle.bottom) {
        if (step < cycle.minimumIncrementalDepth) {
          step = cycle.minimumIncrementalDepth;
        }
        u -= step;
        step -= cycle.incrementalDepthReduction;
        gCycleModal.reset(); // required
        u = Math.max(u, cycle.bottom);
        if (first) {
          first = false;
          writeBlock(
            gRetractModal.format(98), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND ? 74 : 84)),
            getCommonCycle((gPlaneModal.getCurrent() == 19) ? u : x, (gPlaneModal.getCurrent() == 18) ? u : y, (gPlaneModal.getCurrent() == 17) ? u : z, cycle.retract, cycle.clearance),
            pitchOutput.format(F)
          );
        } else {
          writeBlock(
            gRetractModal.format(98), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND ? 74 : 84)),
            conditional(gPlaneModal.getCurrent() == 17, "Z" + xyzFormat.format(u)),
            conditional(gPlaneModal.getCurrent() == 18, "Y" + xyzFormat.format(u)),
            conditional(gPlaneModal.getCurrent() == 19, "X" + xyzFormat.format(u)),
            pitchOutput.format(F)
          );
        }
      }
      forceFeed();
      break;
    case "fine-boring":
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(76),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        "P" + milliFormat.format(P), // not optional
        "Q" + xyzFormat.format(cycle.shift),
        feedOutput.format(F)
      );
      break;
    case "back-boring":
      if (P > 0) {
        expandCyclePoint(x, y, z);
      } else {
        var dx = (gPlaneModal.getCurrent() == 19) ? cycle.backBoreDistance : 0;
        var dy = (gPlaneModal.getCurrent() == 18) ? cycle.backBoreDistance : 0;
        var dz = (gPlaneModal.getCurrent() == 17) ? cycle.backBoreDistance : 0;
        writeBlock(
          gRetractModal.format(98), gCycleModal.format(77),
          getCommonCycle(x - dx, y - dy, z - dz, cycle.bottom, cycle.clearance),
          "Q" + xyzFormat.format(cycle.shift),
          feedOutput.format(F)
        );
      }
      break;
    case "reaming":
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(85),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        feedOutput.format(F)
      );
      break;
    case "stop-boring":
      if (P > 0) {
        expandCyclePoint(x, y, z);
      } else {
        writeBlock(
          gRetractModal.format(98), gCycleModal.format(86),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          feedOutput.format(F)
        );
      }
      break;
    case "manual-boring":
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(88),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        "P" + milliFormat.format(P), // not optional
        feedOutput.format(F)
      );
      break;
    case "boring":
      writeBlock(
        gRetractModal.format(98), gCycleModal.format(89),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        "P" + milliFormat.format(P), // not optional
        feedOutput.format(F)
      );
      break;



    case "probing-x":
      forceXYZ();
      // move slowly always from clearance not retract
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9811,
        "X" + xyzFormat.format(x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter/2)),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "S" + probeWorkOffsetCode // "T" + toolFormat.format(probeToolDiameterOffset)
      );
      break;
    case "probing-y":
      forceXYZ();
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9811,
        "Y" + xyzFormat.format(y + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter/2)),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "S" + probeWorkOffsetCode // "T" + toolFormat.format(probeToolDiameterOffset)
      );
      break;
    case "probing-z":
      forceXYZ();
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(Math.min(z - cycle.depth + cycle.probeClearance, cycle.retract)), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9811,
        "Z" + xyzFormat.format(z - cycle.depth),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "S" + probeWorkOffsetCode // "T" + toolFormat.format(probeToolLengthOffset)
      );
      break;
    case "probing-x-wall":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "X" + xyzFormat.format(cycle.width1),
        zOutput.format(z - cycle.depth),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(cycle.probeClearance),
        "S" + probeWorkOffsetCode // "T" + toolFormat.format(probeToolDiameterOffset)
      );
      break;
    case "probing-y-wall":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Y" + xyzFormat.format(cycle.width1),
        zOutput.format(z - cycle.depth),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(cycle.probeClearance),
        "S" + probeWorkOffsetCode // "T" + toolFormat.format(probeToolDiameterOffset)
      );
      break;
    case "probing-x-channel":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "X" + xyzFormat.format(cycle.width1),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(cycle.probeClearance),
        "S" + probeWorkOffsetCode // "T" + toolFormat.format(probeToolDiameterOffset)
      );
      break;
    case "probing-x-channel-with-island":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "X" + xyzFormat.format(cycle.width1),
        zOutput.format(z - cycle.depth),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-y-channel":
      yOutput.reset();
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Y" + xyzFormat.format(cycle.width1),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-y-channel-with-island":
      yOutput.reset();
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Y" + xyzFormat.format(cycle.width1),
        zOutput.format(z - cycle.depth),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-xy-circular-boss":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9814,
        "D" + xyzFormat.format(cycle.width1),
        "Z" + xyzFormat.format(z - cycle.depth),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-xy-circular-hole":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9814,
        "D" + xyzFormat.format(cycle.width1),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-xy-circular-hole-with-island":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9814,
        "Z" + xyzFormat.format(z - cycle.depth),
        "D" + xyzFormat.format(cycle.width1),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-xy-rectangular-hole":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "X" + xyzFormat.format(cycle.width1),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Y" + xyzFormat.format(cycle.width2),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-xy-rectangular-boss":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Z" + xyzFormat.format(z - cycle.depth),
        "X" + xyzFormat.format(cycle.width1),
        "R" + xyzFormat.format(cycle.probeClearance),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "S" + probeWorkOffsetCode
      );
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Z" + xyzFormat.format(z - cycle.depth),
        "Y" + xyzFormat.format(cycle.width2),
        "R" + xyzFormat.format(cycle.probeClearance),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "S" + probeWorkOffsetCode
      );
      break;
    case "probing-xy-rectangular-hole-with-island":
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Z" + xyzFormat.format(z - cycle.depth),
        "X" + xyzFormat.format(cycle.width1),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      writeBlock(
        gFormat.format(65), "P" + 9812,
        "Z" + xyzFormat.format(z - cycle.depth),
        "Y" + xyzFormat.format(cycle.width2),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        "R" + xyzFormat.format(-cycle.probeClearance),
        "S" + probeWorkOffsetCode
      );
      break;

    case "probing-xy-inner-corner":
      var cornerX = x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter/2);
      var cornerY = y + approach(cycle.approach2) * (cycle.probeClearance + tool.diameter/2);
      var cornerI = 0;
      var cornerJ = 0;
      if (cycle.probeSpacing && (cycle.probeSpacing != 0)) {
        cornerI = cycle.probeSpacing;
        cornerJ = cycle.probeSpacing;
      }
      if ((cornerI != 0) && (cornerJ != 0)) {
        g68RotationMode = 2;
      }
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9815, xOutput.format(cornerX), yOutput.format(cornerY),
        conditional(cornerI != 0, "I" + xyzFormat.format(cornerI)),
        conditional(cornerJ != 0, "J" + xyzFormat.format(cornerJ)),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        conditional((g68RotationMode == 0) || (angularProbingMode == ANGLE_PROBE_USE_CAXIS), "S" + probeWorkOffsetCode)
      );
      break;
    case "probing-xy-outer-corner":
      var cornerX = x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter/2);
      var cornerY = y + approach(cycle.approach2) * (cycle.probeClearance + tool.diameter/2);
      var cornerI = 0;
      var cornerJ = 0;
      if (cycle.probeSpacing && (cycle.probeSpacing != 0)) {
        cornerI = cycle.probeSpacing;
        cornerJ = cycle.probeSpacing;
      }
      if ((cornerI != 0) && (cornerJ != 0)) {
        g68RotationMode = 2;
      }
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9816, xOutput.format(cornerX), yOutput.format(cornerY),
        conditional(cornerI != 0, "I" + xyzFormat.format(cornerI)),
        conditional(cornerJ != 0, "J" + xyzFormat.format(cornerJ)),
        "Q" + xyzFormat.format(cycle.probeOvertravel),
        conditional((g68RotationMode == 0) || (angularProbingMode == ANGLE_PROBE_USE_CAXIS), "S" + probeWorkOffsetCode)
      );
      break;
    case "probing-x-plane-angle":
      forceXYZ();
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9843,
        "X" + xyzFormat.format(x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter/2)),
        "D" + xyzFormat.format(cycle.probeSpacing),
        "Q" + xyzFormat.format(cycle.probeOvertravel)
      );
      g68RotationMode = 1;
      break;
    case "probing-y-plane-angle":
      forceXYZ();
      writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(z - cycle.depth), getFeed(F)); // protected positioning move
      writeBlock(
        gFormat.format(65), "P" + 9843,
        "Y" + xyzFormat.format(y + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter/2)),
        "D" + xyzFormat.format(cycle.probeSpacing),
        "Q" + xyzFormat.format(cycle.probeOvertravel)
      );
      g68RotationMode = 1;
      break;

    default:
      expandCyclePoint(x, y, z);
    }

    // place cycle operation in subprogram
    if (cycleSubprogramIsActive) {
      if (forceCycle || cycleExpanded || isProbeOperation()) {
        cycleSubprogramIsActive = false;
      } else {
        // call subprogram
        writeBlock(mFormat.format(98), "P" + oFormat.format(currentSubprogram));
        subprogramStart(new Vector(x, y, z), new Vector(0, 0, 0), false);
      }
    }

  // 2nd through nth cycle point
  } else {
    if (isProbeOperation()) {
      // do nothing
    } else if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      var _x;
      var _y;
      var _z;
      if (!xyzFormat.areDifferent(x, xOutput.getCurrent()) &&
          !xyzFormat.areDifferent(y, yOutput.getCurrent()) &&
          !xyzFormat.areDifferent(z, zOutput.getCurrent())) {
        switch (gPlaneModal.getCurrent()) {
        case 17: // XY
          xOutput.reset(); // at least one axis is required
          break;
        case 18: // ZX
          zOutput.reset(); // at least one axis is required
          break;
        case 19: // YZ
          yOutput.reset(); // at least one axis is required
          break;
        }
      }
      if (incrementalMode) {
        switch (gPlaneModal.getCurrent()) {
        case 17: // XY
          zOutput.format(cycle.retract);
          break;
        case 18: // ZX
          yOutput.format(cycle.retract);
          break;
        case 19: // YZ
          xOutput.format(cycle.retract);
          break;
        }
      }
      writeBlock(xOutput.format(x), yOutput.format(y), zOutput.format(z));
    }
  }
}

function onCycleEnd() {
  if (isProbeOperation()) {
    writeBlock(gFormat.format(65), "P" + 9810, zOutput.format(cycle.clearance)); // protected retract move
    writeBlock(gFormat.format(65), "P" + 9833); // spin the probe off
    setProbingAngle(); // define rotation of part
    // we can move in rapid from retract optionally
  } else {
    if (cycleSubprogramIsActive) {
      subprogramEnd();
      cycleSubprogramIsActive = false;
    }
    if (!cycleExpanded) {
      //writeBlock(gCycleModal.format(80), conditional(properties.useG95forTapping, gFeedModeModal.format(94)));
      gMotionModal.reset();
    }
  }
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    if (!properties.useG0 && (((x ? 1 : 0) + (y ? 1 : 0) + (z ? 1 : 0)) > 1)) {
      // axes are not synchronized
      writeBlock(gMotionModal.format(1), x, y, z, getFeed(highFeedrate));
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
      forceFeed();
    }
  }
}

function onLinear(_x, _y, _z, feed) {
//RW Diabase disable modal on circle
gMotionModal.reset();
  if (pendingRadiusCompensation >= 0) {
    // ensure that we end at desired position when compensation is turned off
    xOutput.reset();
    yOutput.reset();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      var d = tool.diameterOffset;
      if (d > 200) {
        warning(localize("The diameter offset exceeds the maximum value."));
      }
      //writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        dOutput.reset();
        writeBlock(/*gFeedModeModal.format(94), */gMotionModal.format(1), gFormat.format(41), x, y, z, dOutput.format(d), f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        dOutput.reset();
        writeBlock(/*gFeedModeModal.format(94), */gMotionModal.format(1), gFormat.format(42), x, y, z, dOutput.format(d), f);
        break;
      default:
        writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  
  if (!properties.useG0) {
    // axes are not synchronized
    onLinear5D(_x, _y, _z, _a, _b, _c, highFeedrate);
  } else {
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
    forceFeed();
  }
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
//RW Diabase disable modal on circle
gMotionModal.reset();
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_a);
  var c = cOutput.format(_c);

  // get feedrate number
  var f = {frn:0, fmode:0};
  if (a || b || c) {
   // RW Diabase was: f = getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed);
    f.frn = feedOutput.format(feed);
    f.fmode = 94;
  } else {
    f.frn = feedOutput.format(feed);
    f.fmode = 94;
  }

  if (x || y || z || a || b || c) {
  
    writeBlock(gFeedModeModal.format(f.fmode), gMotionModal.format(1), x, y, z, a,b, b, c, f.frn);
  } else if (f.frn) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      writeBlock(gFeedModeModal.format(f.fmode), gMotionModal.format(1), f.frn);
    }
  }
}

// Start of multi-axis feedrate logic
/***** Be sure to add 'useInverseTime' to post properties if necessary. *****/
/***** 'inverseTimeOutput' must be defined. *****/
/***** 'headOffset' should be defined when a head rotary axis is defined. *****/
/***** The feedrate mode must be included in motion block output (linear, circular, etc. *****/
var dpmBPW = 0.1; // ratio of rotary accuracy to linear accuracy for DPM calculations
var inverseTimeUnits = 1.0; // 1.0 = minutes, 60.0 = seconds
var maxInverseTime = 45000; // maximum value to output for Inverse Time feeds

/** Calculate the multi-axis feedrate number. */
function getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed) {
  var f = {frn:0, fmode:0};
  if (feed <= 0) {
    error(localize("Feedrate is less than or equal to 0."));
    return f;
  }
  
  var length = getMoveLength(_x, _y, _z, _a, _b, _c);

  if (true) { // inverse time RW Dibase was true
    f.frn = inverseTimeOutput.format(getInverseTime(length[0], feed));
    f.fmode = 93;
    feedOutput.reset();
  } else { // degrees per minute
    f.frn = feedOutput.format(getFeedDPM(length, feed));
    f.fmode = 94;
  }
  return f;
}

/** Calculate the DPM feedrate number. */
function getFeedDPM(_moveLength, _feed) {
  // moveLength[0] = Tool tip, [1] = XYZ, [2] = ABC
  
  if (false) { // TCP mode is supported, output feed as FPM
    return feed;
  } else { // DPM feedrate calculation
    var moveTime = ((_moveLength[0] < 1.e-6) ? 0.001 : _moveLength[0]) / _feed;
    var length = Math.sqrt(Math.pow(_moveLength[1], 2.0) + Math.pow((toDeg(_moveLength[2]) * dpmBPW), 2.0));
    return length / moveTime;
  }
}

/** Calculate the Inverse time feedrate number. */
function getInverseTime(_length, _feed) {
  var inverseTime;
  if (_length < 1.e-6) { // tool doesn't move
    if (typeof maxInverseTime === "number") {
      inverseTime = maxInverseTime;
    } else {
      inverseTime = 999999;
    }
  } else {
    inverseTime = _feed / _length / inverseTimeUnits;
    if (typeof maxInverseTime === "number") {
      if (inverseTime > maxInverseTime) {
        inverseTime = maxInverseTime;
      }
    }
  }
  return inverseTime;
}

/** Calculate the distance of the tool position to the center of a rotary axis. */
function getRotaryRadius(center, direction, toolPosition) {
  var normal = direction.getNormalized();
  var d1 = toolPosition.x - center.x;
  var d2 = toolPosition.y - center.y;
  var d3 = toolPosition.z - center.z;
  var radius = Math.sqrt(
    Math.pow((d1 * normal.y) - (d2 * normal.x), 2.0) +
    Math.pow((d2 * normal.z) - (d3 * normal.y), 2.0) +
    Math.pow((d3 * normal.x) - (d1 * normal.z), 2.0)
   );
   return radius;
}

/** Calculate the linear distance based on the rotation of a rotary axis. */
function getRadialDistance(axis, startTool, endTool, startABC, endABC) {
  // rotary axis does not exist
  if (!axis.isEnabled()) {
    return 0.0;
  }

  // calculate the rotary center based on head/table
  var center;
  if (axis.isHead()) {
    var pivot;
    if (typeof headOffset === "number") {
      pivot = headOffset;
    } else {
      pivot = tool.getBodyLength();
    }
    center = Vector.sum(startTool, Vector.product(machineConfiguration.getSpindleAxis(), pivot));
    center = Vector.sum(center, axis.getOffset());
  } else {
    center = axis.getOffset();
  }

  // calculate the radius of the tool end point compared to the rotary center
  var startRadius = getRotaryRadius(center, axis.getEffectiveAxis(), startTool);
  var endRadius = getRotaryRadius(center, axis.getEffectiveAxis(), endTool);

  // calculate length of radial move
  var radius = Math.max(startRadius, endRadius);
  var delta = Math.abs(endABC.getCoordinate(axis.getCoordinate()) - startABC.getCoordinate(axis.getCoordinate()));
  if (delta > Math.PI) {
    delta = 2 * Math.PI - delta;
  }
  var radialLength = (2 * Math.PI * radius) * (delta / (2 * Math.PI));
  return radialLength;
}

/** Calculate tooltip, XYZ, and rotary move lengths. */
function getMoveLength(_x, _y, _z, _a, _b, _c) {
  // get starting and ending positions
  var moveLength = new Array();
  var startTool;
  var endTool;
  var startXYZ;
  var endXYZ;
  var startABC = getCurrentDirection();
  var endABC = new Vector(_a, _b, _c);
  
  if (currentSection.getOptimizedTCPMode() == 0) {
    startTool = getCurrentPosition();
    endTool = new Vector(_x, _y, _z);
    startXYZ = machineConfiguration.getOrientation(startABC).getTransposed().multiply(startTool);
    endXYZ = machineConfiguration.getOrientation(endABC).getTransposed().multiply(endTool);
  } else {
    startXYZ = getCurrentPosition();
    endXYZ = new Vector(_x, _y, _z);
    startTool = machineConfiguration.getOrientation(startABC).multiply(startXYZ);
    endTool = machineConfiguration.getOrientation(endABC).multiply(endXYZ);
  }

  // calculate the radial portion of the move
  var radialLength = Math.sqrt(
    Math.pow(getRadialDistance(machineConfiguration.getAxisU(), startTool, endTool, startABC, endABC), 2.0) +
    Math.pow(getRadialDistance(machineConfiguration.getAxisV(), startTool, endTool, startABC, endABC), 2.0) +
    Math.pow(getRadialDistance(machineConfiguration.getAxisW(), startTool, endTool, startABC, endABC), 2.0)
  );

  // calculate the lengths of move
  // tool tip distance is the move distance based on a combination of linear and rotary axes movement
  var linearLength = Vector.diff(endXYZ, startXYZ).length;
  moveLength[0] = linearLength + radialLength;
  moveLength[1] = Vector.diff(endXYZ, startXYZ).length;
  moveLength[2] = 0;
  for (var i = 0; i < 3; ++i) {
    var delta = Math.abs(endABC[i] - startABC[i]);
    if (delta > Math.PI) {
      delta = 2 * Math.PI - delta;
    }
    moveLength[2] += Math.pow(delta, 2.0);
  }
  moveLength[2] = Math.sqrt(moveLength[2]);
  return moveLength;
}
// End of multi-axis feedrate logic

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
//RW Diabase disable modal on circle
gMotionModal.reset();
  if (isSpiral()) {
    var startRadius = getCircularStartRadius();
    var endRadius = getCircularRadius();
    var dr = Math.abs(endRadius - startRadius);
    if (dr > maximumCircularRadiiDifference) { // maximum limit
      linearize(tolerance); // or alternatively use other G-codes for spiral motion
      return;
    }
  }
  
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (!properties.useRadius) {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else { // use radius mode
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(/*gPlaneModal.format(17), gFeedModeModal.format(94), */gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var currentCoolantMode = COOLANT_OFF;

function setCoolant(coolant) {
  if (isProbeOperation()) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }

  if (coolant == currentCoolantMode) {
    if (operationNeedsSafeStart) {
      operationNeedsSafeCoolant = true;
    } else {
      return; // coolant is already active
    }
  }

  var m = undefined;
  var m2 = undefined;
  if (coolant == COOLANT_OFF) {
    if (currentCoolantMode == COOLANT_THROUGH_TOOL) {
      m = 89;
    } else if (currentCoolantMode == COOLANT_AIR) {
      m = 84;
    } else if (currentCoolantMode == COOLANT_AIR_THROUGH_TOOL) {
      m = 74;
    } else if (currentCoolantMode == COOLANT_FLOOD_THROUGH_TOOL) {
      m = 89;
      m2 = 107;
    } else {
      m = 107;
    }
    writeBlock("M4 P0 S0")
	writeBlock("M4 P1 S0")
	writeBlock("M4 P2 S0")
	writeBlock("M4 P3 S0"); //added by AR to turn off spindles
	writeBlock("M106 P4 S0")
	writeBlock("M106 P5 S0")
	writeBlock("M106 P6 S0")
	writeBlock("M106 P7 S0"); //added by AR to turn off fan
    if (m2) {
      writeBlock(mFormat.format(m2));
    }
    currentCoolantMode = COOLANT_OFF;
    return;
  }

  if ((currentCoolantMode != COOLANT_OFF) && !operationNeedsSafeCoolant) {
    setCoolant(COOLANT_OFF);
  }

  switch (coolant) {
  case COOLANT_FLOOD:
    m = 106;
    break;
  case COOLANT_THROUGH_TOOL:
    m = 88;
    break;
  case COOLANT_AIR:
    m = 83;
    break;
  case COOLANT_AIR_THROUGH_TOOL:
    m = 73;
    break;
  case COOLANT_FLOOD_THROUGH_TOOL:
    m = 88;
    m2 = 8;
    break;
  default:
    warning(localize("Coolant not supported."));
    if (currentCoolantMode == COOLANT_OFF) {
      return;
    }
    coolant = COOLANT_OFF;
	writeBlock(operationNeedsSafeCoolant ? "/" : "", mFormat.format(m),"P",toolFormat.format(tool.number+3),"S0" );
    m = 107;
  }

  writeBlock(operationNeedsSafeCoolant ? "/" : "", mFormat.format(m),"P",toolFormat.format(tool.number+3),"S1" );
  if (m2) {
    writeBlock(operationNeedsSafeCoolant ? "/" : "", mFormat.format(m2),"Diabase");
  }
  currentCoolantMode = coolant;
}

var mapCommand = {
  COMMAND_STOP:0,
  COMMAND_OPTIONAL_STOP:1,
  COMMAND_END:2,
  COMMAND_SPINDLE_CLOCKWISE:3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE:4,
  COMMAND_STOP_SPINDLE:5,
  COMMAND_ORIENTATE_SPINDLE:19,
  COMMAND_LOAD_TOOL:6
};

function onCommand(command) {
  switch (command) {
  case COMMAND_STOP:
    
    forceSpindleSpeed = true;
    return;
  case COMMAND_COOLANT_ON:
    setCoolant(COOLANT_FLOOD);
    return;
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
	return;
  case COMMAND_START_SPINDLE:
    onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    return;
  case COMMAND_LOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getNumberOfAxes() >= 4)) {
      //writeBlock(operationNeedsSafeWorkPlane ? "/" : "", mFormat.format(100)); // lock 4th-axis motion
      if (machineConfiguration.getNumberOfAxes() == 5) {
        //writeBlock(operationNeedsSafeWorkPlane ? "/" : "", mFormat.format(12)); // lock 5th-axis motion
      }
    }
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getNumberOfAxes() >= 4)) {
      //writeBlock(operationNeedsSafeWorkPlane ? "/" : "", mFormat.format(110)); // unlock 4th-axis motion
      if (machineConfiguration.getNumberOfAxes() == 5) {
        //writeBlock(operationNeedsSafeWorkPlane ? "/" : "", mFormat.format(13)); // unlock 5th-axis motion
      }
    }
    return;
  case COMMAND_BREAK_CONTROL:
    if (!toolChecked) { // avoid duplicate COMMAND_BREAK_CONTROL
      onCommand(COMMAND_STOP_SPINDLE);
      onCommand(COMMAND_COOLANT_OFF);
      writeBlock(
        gFormat.format(65),
        "P" + 9853,
        "T" + toolFormat.format(tool.number),
        "B" + xyzFormat.format(0),
        "H" + xyzFormat.format(properties.toolBreakageTolerance)
      );
      toolChecked = true;
    }
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  case COMMAND_START_CHIP_TRANSPORT:
    writeBlock(mFormat.format(31));
    return;
  case COMMAND_STOP_CHIP_TRANSPORT:
    writeBlock(mFormat.format(33));
    return;
  }
  
  var stringId = getCommandStringId(command);
  var mcode = mapCommand[stringId];
  if (mcode != undefined) {
    writeBlock(mFormat.format(mcode));
  } else {
    onUnsupportedCommand(command);
  }
}

var toolChecked = false; // specifies that the tool has been checked with the probe

function onSectionEnd() {
  if (currentSection.isMultiAxis()) {
    //writeBlock(gFeedModeModal.format(94)); // inverse time feed off
  }
  
  if ((((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
      (tool.number != getNextSection().getTool().number)) &&
      tool.breakControl) {
    onCommand(COMMAND_BREAK_CONTROL);
  } else {
    toolChecked = false;
  }

  if (true) {
    if (isRedirecting()) {
      if (firstPattern) {
        var finalPosition = getFramePosition(currentSection.getFinalPosition());
        var abc;
        if (currentSection.isMultiAxis() && machineConfiguration.isMultiAxisConfiguration()) {
          abc = currentSection.getFinalToolAxisABC();
        } else {
          abc = currentWorkPlaneABC;
        }
        if (abc == undefined) {
          abc = new Vector(0, 0, 0);
        }
        setAbsoluteMode(finalPosition, abc);
        subprogramEnd();
      }
    }
  }
  forceAny();

  operationNeedsSafeStart = false; // reset for next section
  operationNeedsSafeToolCall = false;
  operationNeedsSafeWorkOffset = false;
  operationNeedsSafeWorkPlane = false;
  operationNeedsSafeCoolant = false;
}

function onClose() {
  writeln("M42 P5 S1");
  writeln("M3 P0 S0");
  writeln("M3 P1 S0");
  writeln("M3 P2 S0");
  writeln("M3 P3 S0");
  writeln("M106 P4 S0");
  writeln("M106 P5 S0");
  writeln("M106 P6 S0");
  writeln("M106 P7 S0");
  writeln("M0 H1");

  }

/*
function onTerminate() {
  var outputPath = getOutputPath();
  var programFilename = FileSystem.getFilename(outputPath);
  var programSize = FileSystem.getFileSize(outputPath);
  var postPath = findFile("setup-sheet-excel-2007.cps");
  var intermdiatePath = FileSystem.replaceExtension(outputPath, "cnc");
  var a = "--property unit 0"; // use 0 for inch and 1 for mm
  if (programName) {
    a += " --property programName \"'" + programName + "'\"";
  }
  if (programComment) {
    a += " --property programComment \"'" + programComment + "'\"";
  }
  a += " --property programFilename \"'" + programFilename + "'\"";
  a += " --property programSize \"" + programSize + "\"";
  a += " --noeditor --log temp.log \"" + postPath + "\" \"" + intermdiatePath + "\" \"" + outputPath + ".xlsx\"";
  execute(getPostProcessorPath(), a, false, "");
}
*/
