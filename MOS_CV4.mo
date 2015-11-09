package MOS_CV4
  connector BloodFlowConnector
    flow Real Q(unit = "ml/s") "blood flow in ml/sec";
    Real Pressure(unit = "torr") "Pressure in torr";
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-101, 101}, {99, -99}})}));
  end BloodFlowConnector;

  connector BloodFlowInflow
    flow Real Q(unit = "ml/s") "blood flow in ml/sec";
    Real Pressure(unit = "torr") "Pressure in torr";
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
  end BloodFlowInflow;

  connector BloodFlowOutflow
    flow Real Q(unit = "ml/s") "blood flow in ml/sec";
    Real Pressure(unit = "torr") "Pressure in torr";
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {238, 238, 238}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
  end BloodFlowOutflow;

  partial model BloodFlowOnePort
    Real PressureDrop(unit = "torr");
    Real BloodFlow(unit = "ml/s");
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {-90, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    PressureDrop = Inflow.Pressure - Outflow.Pressure;
    Inflow.Q + Outflow.Q = 0;
    //nehromadí se krev!!
    BloodFlow = Inflow.Q;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end BloodFlowOnePort;

  model BloodResisitor
    extends MOS_CV4.BloodFlowOnePort;
    parameter Real BloodResistance(start = 1, unit = "torr.s/ml") "resistance in torr sec/ml";
  equation
    PressureDrop = BloodFlow * BloodResistance;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {204, 204, 204}, fillPattern = FillPattern.Solid, extent = {{-80, 40}, {80, -40}}), Text(origin = {18, 32}, extent = {{-42, -60}, {8, -2}}, textString = "R"), Text(origin = {8, 58}, extent = {{-60, 24}, {52, -18}}, textString = "%name")}));
  end BloodResisitor;

  model VariableBloodResistor
    extends MOS_CV4.BloodFlowOnePort;
    Modelica.Blocks.Interfaces.RealInput BloodResistance(unit = "torr.s/ml") annotation(Placement(visible = true, transformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  equation
    PressureDrop = BloodFlow * BloodResistance;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {179, 179, 179}, fillPattern = FillPattern.Solid, extent = {{-80, 40}, {80, -40}}), Text(origin = {0, 3}, extent = {{-46, 33}, {46, -33}}, textString = "R"), Text(origin = {8, -63}, extent = {{-88, 37}, {58, -25}}, textString = "%name")}));
  end VariableBloodResistor;

  model Inductor
    extends MOS_CV4.BloodFlowOnePort;
    Modelica.Blocks.Interfaces.RealInput Inertance(unit = "torr.s2/ml") annotation(Placement(visible = true, transformation(origin = {0, 88}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  equation
    PressureDrop = der(BloodFlow) * Inertance;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(lineThickness = 1, extent = {{-80, 60}, {80, -60}}), Rectangle(origin = {-1, 2}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-39, 52}, {39, -52}}), Text(origin = {-5, 51}, extent = {{-73, 25}, {79, -47}}, textString = "Inertance"), Text(origin = {-2, -75}, extent = {{-112, 19}, {112, -19}}, textString = "%name")}));
  end Inductor;

  model BloodElasticCompartment
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real V0(unit = "ml") = 1;
    Real TransmuralPressure(unit = "torr");
    Modelica.Blocks.Interfaces.RealInput Elastance(unit = "torr/ml") annotation(Placement(visible = true, transformation(origin = {60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {76, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput ExternalPressure(unit = "torr") annotation(Placement(visible = true, transformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 116}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput UnstressedVolume(unit = "ml") annotation(Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealOutput Pressure(unit = "torr") annotation(Placement(visible = true, transformation(origin = {60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealOutput StressedVolume(start = V0, unit = "ml") annotation(Placement(visible = true, transformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {2, -118}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealOutput Volume(start = V0, unit = "ml") annotation(Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  equation
    Inflow.Pressure = Outflow.Pressure;
    Inflow.Pressure = Pressure;
    TransmuralPressure = Pressure - ExternalPressure;
    der(Volume) = Inflow.Q + Outflow.Q;
    StressedVolume = Volume - UnstressedVolume;
    if StressedVolume > 0 then
      TransmuralPressure = Elastance * StressedVolume;
    else
      TransmuralPressure = 0;
    end if;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(origin = {3, -13}, fillColor = {188, 188, 188}, fillPattern = FillPattern.Solid, extent = {{-103, 113}, {97, -87}}, endAngle = 360), Text(origin = {-109, 74}, extent = {{-29, 12}, {21, -14}}, textString = "UV"), Text(origin = {-23, 46}, extent = {{-29, 12}, {63, -38}}, textString = "%name"), Text(origin = {5, 82}, extent = {{-29, 12}, {21, -14}}, textString = "Pext"), Text(origin = {157, 60}, extent = {{-75, 26}, {21, -14}}, textString = "Elastance"), Text(origin = {-65, -44}, extent = {{-51, 16}, {21, -14}}, textString = "Volume"), Text(origin = {47, -98}, extent = {{-111, 34}, {21, -14}}, textString = "StressedVolume"), Text(origin = {97, -44}, extent = {{-51, 14}, {21, -14}}, textString = "Pressure")}));
  end BloodElasticCompartment;

  model Valve
    BloodFlowInflow bloodFlowInflow annotation(Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow bloodFlowOutflow annotation(Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Real q;
    Real dp;
    Boolean open(start = true);
    Real passableVariable;
  equation
    bloodFlowInflow.Q + bloodFlowOutflow.Q = 0;
    q = bloodFlowInflow.Q;
    dp = bloodFlowInflow.Pressure - bloodFlowOutflow.Pressure;
    open = passableVariable > 0;
    if open then
      dp = 0;
      q = passableVariable;
    else
      dp = passableVariable;
      q = 0;
    end if;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {67, -1}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-13, 81}, {13, -79}}), Polygon(origin = {-14, -1.01}, fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, points = {{-64, 81.0114}, {-64, -78.9886}, {66, -18.9886}, {66, 21.0114}, {-64, 81.0114}, {-64, 81.0114}}), Text(origin = {-6, 91}, extent = {{-48, 17}, {48, -17}}, textString = "%name")}));
  end Valve;

  model VariableBloodConductance
    extends MOS_CV4.BloodFlowOnePort;
    Modelica.Blocks.Interfaces.RealInput BloodConductance annotation(Placement(visible = true, transformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  equation
    PressureDrop * BloodConductance = BloodFlow;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {179, 179, 179}, fillPattern = FillPattern.Solid, extent = {{-80, 40}, {80, -40}}), Text(origin = {0, 3}, extent = {{-46, 33}, {46, -33}}, textString = "G"), Text(origin = {8, -63}, extent = {{-88, 37}, {58, -25}}, textString = "%name")}));
  end VariableBloodConductance;

  model CardiacValve
    VariableBloodConductance BackflowConductor annotation(Placement(visible = true, transformation(origin = {-44, -66}, extent = {{-16, -16}, {16, 16}}, rotation = 180)));
    Valve BackflowValve annotation(Placement(visible = true, transformation(origin = {46, -66}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    VariableBloodResistor OutflowResistor annotation(Placement(visible = true, transformation(origin = {45, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Valve OutflowValve annotation(Placement(visible = true, transformation(origin = {-53, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput RR annotation(Placement(visible = true, transformation(origin = {-76, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-76, 86}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput CR annotation(Placement(visible = true, transformation(origin = {-76, -82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {78, 86}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  equation
    connect(RR, OutflowResistor.BloodResistance) annotation(Line(points = {{-76, 86}, {46, 86}, {46, 78}, {46, 78}}, color = {0, 0, 127}));
    connect(BackflowConductor.BloodConductance, CR) annotation(Line(points = {{-44, -79}, {-64, -79}, {-64, -80}, {-64, -80}}, color = {0, 0, 127}));
    connect(OutflowValve.bloodFlowInflow, BackflowConductor.Outflow) annotation(Line(points = {{-67, 67}, {-68, 67}, {-68, -66}, {-58, -66}}));
    connect(OutflowResistor.Inflow, OutflowValve.bloodFlowOutflow) annotation(Line(points = {{30, 67}, {-38, 67}}));
    connect(bloodFlowInflow1, OutflowValve.bloodFlowInflow) annotation(Line(points = {{-92, 0}, {-73, 0}, {-73, 33.5}, {-67, 33.5}, {-67, 67}}));
    connect(Outflow, OutflowResistor.Outflow) annotation(Line(points = {{92, 0}, {60, 0}, {60, 67}}));
    connect(BackflowValve.bloodFlowInflow, OutflowResistor.Outflow) annotation(Line(points = {{60, -66}, {60, 67}}));
    connect(BackflowConductor.Inflow, BackflowValve.bloodFlowOutflow) annotation(Line(points = {{-30, -66}, {30, -66}}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {-53, -56}, extent = {{111, 28}, {-1, 0}}, textString = "%name"), Polygon(origin = {0, 10}, fillColor = {255, 85, 0}, fillPattern = FillPattern.Solid, points = {{-80, 70}, {-80, -70}, {80, 70}, {80, -70}, {-80, 70}}), Text(origin = {-57, 13}, extent = {{-19, 41}, {19, -41}}, textString = "C"), Text(origin = {55, 14}, extent = {{-19, 32}, {19, -32}}, textString = "V"), Text(origin = {58, 84}, lineColor = {18, 232, 7}, fillColor = {30, 222, 20}, extent = {{-10, 14}, {10, -14}}, textString = "CR"), Text(origin = {-54, 88}, lineColor = {232, 206, 4}, fillColor = {219, 222, 26}, extent = {{-10, 14}, {10, -14}}, textString = "RR")}));
  end CardiacValve;

  model HeartIntervals
    Boolean b;
    Real HP;
    discrete Modelica.Blocks.Interfaces.RealOutput T0 annotation(Placement(visible = true, transformation(origin = {117, -85}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {92, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput HR annotation(Placement(visible = true, transformation(origin = {-118, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    discrete Modelica.Blocks.Interfaces.RealOutput Tas annotation(Placement(visible = true, transformation(origin = {112, 76}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {90, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    discrete Modelica.Blocks.Interfaces.RealOutput Tav annotation(Placement(visible = true, transformation(origin = {112, 34}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {92, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    discrete Modelica.Blocks.Interfaces.RealOutput Tvs annotation(Placement(visible = true, transformation(origin = {114, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {96, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    b = time - pre(T0) >= pre(HP);
    when {initial(), b} then
      T0 = time;
      HP = 60 / HR;
      Tas = 0.03 + 0.09 * HP;
      Tav = 0.01;
      Tvs = 0.16 + 0.2 * HP;
    end when;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Line(origin = {-34, -7}, points = {{0, 27}, {0, -27}, {0, -27}}), Rectangle(origin = {5, -8}, extent = {{-55, 42}, {55, -42}}), Text(origin = {-18, 8}, extent = {{-12, 6}, {74, -42}}, textString = "HeartI"), Text(origin = {79, 86}, extent = {{13, -16}, {-5, 4}}, textString = "Tas"), Text(origin = {71, -87}, extent = {{-5, 3}, {5, -3}}, textString = "T0"), Text(origin = {-77, 23}, extent = {{-7, 9}, {7, -9}}, textString = "HR"), Text(origin = {81, 44}, extent = {{13, -16}, {-5, 4}}, textString = "Tav"), Text(origin = {83, 10}, extent = {{13, -16}, {-5, 4}}, textString = "Tvs")}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {5, -4}, extent = {{-57, 48}, {57, -48}}), Text(origin = {73, 88}, extent = {{-15, -10}, {1, 0}}, textString = "Tas"), Text(origin = {65, -86}, extent = {{5, -4}, {-5, 4}}, textString = "T0"), Text(origin = {8, -1}, extent = {{-52, 29}, {52, -29}}, textString = "HeartI"), Text(origin = {-83, 28}, extent = {{-9, 8}, {9, -8}}, textString = "HR"), Text(origin = {83, -20}, extent = {{-15, -10}, {1, 0}}, textString = "Tvs"), Text(origin = {75, 44}, extent = {{-15, -10}, {1, 0}}, textString = "Tav")}));
  end HeartIntervals;

  model AtrialElastance
    Modelica.Blocks.Interfaces.RealInput Tas "duration of atrial systole" annotation(Placement(visible = true, transformation(origin = {-98, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput T0 "time of start of cardiac cycle " annotation(Placement(visible = true, transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput Et "elasticity (torr/ml)" annotation(Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real EMIN = 0.05 "Diastolic elastance (torr/ml)";
    parameter Real EMAX = 0.15 "Maximum systolic elastance (tor/ml)";
  equation
    if time - T0 < Tas then
      Et = EMIN + (EMAX - EMIN) * sin(Modelica.Constants.pi * (time - T0) / Tas);
    else
      Et = EMIN;
    end if;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Line(origin = {0.896275, 25.8932}, points = {{-76.8963, -41.8932}, {-60.8963, 24.1068}, {-42.8963, 40.1068}, {-24.8963, 42.1068}, {-12.8963, 14.1068}, {-4.89627, -31.8932}, {-2.89627, -39.8932}, {77.1037, -39.8932}, {77.1037, -39.8932}}), Text(origin = {13, 70}, extent = {{-33, 18}, {33, -18}}, textString = "%name"), Text(origin = {3, -59}, extent = {{-69, 29}, {69, -29}}, textString = "Arterial Elastance")}));
  end AtrialElastance;

  model VentricularElastance
    constant Real Kn = 0.57923032735652;
    parameter Real EMIN = 0 "Diastolic elastance (torr/ml)";
    parameter Real EMAX = 1 "Maximum systolic elastance (tor/ml)";
    Modelica.Blocks.Interfaces.RealInput Tas annotation(Placement(visible = true, transformation(origin = {-80, 74}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput Et annotation(Placement(visible = true, transformation(origin = {74, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput Et0 annotation(Placement(visible = true, transformation(origin = {84, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput HeartInterval annotation(Placement(visible = true, transformation(origin = {82, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {96, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput T0 annotation(Placement(visible = true, transformation(origin = {-80, -74}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, -62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tvs annotation(Placement(visible = true, transformation(origin = {-80, -26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, -16}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tav annotation(Placement(visible = true, transformation(origin = {-80, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  equation
    HeartInterval = time - T0;
    Et = EMIN + (EMAX - EMIN) * Et0;
    if HeartInterval >= Tas + Tav and HeartInterval < Tas + Tav + Tvs then
      Et0 = (HeartInterval - (Tas + Tav)) / Tvs * sin(Modelica.Constants.pi * (HeartInterval - (Tas + Tav)) / Tvs) / Kn;
    else
      Et0 = 0;
    end if;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {-71, 69}, extent = {{-7, 7}, {7, -7}}, textString = "Tas"), Text(origin = {-59, 17}, extent = {{-7, 7}, {7, -7}}, textString = "Tav"), Text(origin = {-55, -23}, extent = {{-7, 7}, {7, -7}}, textString = "Tvs"), Text(origin = {-59, -63}, extent = {{-7, 7}, {7, -7}}, textString = "T0"), Text(origin = {51, 73}, extent = {{-7, 7}, {7, -7}}, textString = "Et"), Text(origin = {49, -17}, extent = {{-7, 7}, {7, -7}}, textString = "Et0"), Text(origin = {69, -73}, extent = {{-29, 9}, {11, -7}}, textString = "HeartInterval"), Text(origin = {-35, 31}, extent = {{-7, 7}, {95, -17}}, textString = "Ventricular Elastance"), Ellipse(origin = {-3, -44}, fillColor = {204, 27, 166}, fillPattern = FillPattern.Horizontal, extent = {{-41, 52}, {41, -52}}, endAngle = 360)}));
  end VentricularElastance;

  model RightHeart
    BloodElasticCompartment RightAtrium annotation(Placement(visible = true, transformation(origin = {-50, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodElasticCompartment RightVentricle annotation(Placement(visible = true, transformation(origin = {48, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow bloodFlowOutflow1 annotation(Placement(visible = true, transformation(origin = {112, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    AtrialElastance atrialElastance1 annotation(Placement(visible = true, transformation(origin = {-42, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    VentricularElastance ventricularElastance1 annotation(Placement(visible = true, transformation(origin = {50, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(visible = true, transformation(origin = {-100, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant const5 annotation(Placement(visible = true, transformation(origin = {90, 4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    CardiacValve tricuspidValve annotation(Placement(visible = true, transformation(origin = {-12, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant const3 annotation(Placement(visible = true, transformation(origin = {-22, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant const1 annotation(Placement(visible = true, transformation(origin = {16, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    CardiacValve pulmonicValve annotation(Placement(visible = true, transformation(origin = {78, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant const4 annotation(Placement(visible = true, transformation(origin = {66, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant const2 annotation(Placement(visible = true, transformation(origin = {96, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Interfaces.RealInput u1 annotation(Placement(visible = true, transformation(origin = {-98, 66}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, 66}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput u2 annotation(Placement(visible = true, transformation(origin = {-96, 68}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-96, 68}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput u3 annotation(Placement(visible = true, transformation(origin = {-94, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-94, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant const annotation(Placement(visible = true, transformation(origin = {-90, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput PTH annotation(Placement(visible = true, transformation(origin = {-96, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-92, 72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    BloodFlowInflow bloodFlowInflow1 annotation(Placement(visible = true, transformation(origin = {-94, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-88, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(tricuspidValve.RR, const3.y) annotation(Line(points = {{-20, -53}, {-22, -53}, {-22, -70}, {-22, -70}}, color = {0, 0, 127}));
    connect(tricuspidValve.CR, const1.y) annotation(Line(points = {{-4, -53}, {16, -53}, {16, -74}, {16, -74}}, color = {0, 0, 127}));
    connect(pulmonicValve.CR, const2.y) annotation(Line(points = {{86, -53}, {96, -53}, {96, -70}, {96, -70}}, color = {0, 0, 127}));
    connect(pulmonicValve.RR, const4.y) annotation(Line(points = {{70, -53}, {66, -53}, {66, -68}, {66, -68}, {66, -68}}, color = {0, 0, 127}));
    connect(bloodFlowOutflow1, pulmonicValve.Outflow) annotation(Line(points = {{112, -42}, {86, -42}, {86, -44}, {86, -44}}));
    connect(pulmonicValve.Inflow, RightVentricle.Outflow) annotation(Line(points = {{69, -44}, {58, -44}, {58, -44}, {58, -44}}));
    connect(RightVentricle.Inflow, tricuspidValve.Outflow) annotation(Line(points = {{39, -44}, {-4, -44}, {-4, -44}, {-4, -44}}));
    connect(RightAtrium.Outflow, tricuspidValve.Inflow) annotation(Line(points = {{-41, -44}, {-22, -44}, {-22, -44}, {-22, -44}}));
    connect(RightAtrium.Inflow, bloodFlowInflow1) annotation(Line(points = {{-59, -44}, {-94, -44}, {-94, -50}}));
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end RightHeart;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end MOS_CV4;