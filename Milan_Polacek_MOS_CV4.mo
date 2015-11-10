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
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    VariableBloodResistor OutflowResistor annotation(Placement(visible = true, transformation(origin = {45, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Valve OutflowValve annotation(Placement(visible = true, transformation(origin = {-53, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput RR annotation(Placement(visible = true, transformation(origin = {-76, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-76, 86}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput CR annotation(Placement(visible = true, transformation(origin = {-76, -82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {78, 86}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {-90, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(Inflow, OutflowValve.bloodFlowInflow) annotation(Line(points = {{-90, -4}, {-67, -4}, {-67, 67}}));
    connect(RR, OutflowResistor.BloodResistance) annotation(Line(points = {{-76, 86}, {46, 86}, {46, 78}, {46, 78}}, color = {0, 0, 127}));
    connect(BackflowConductor.BloodConductance, CR) annotation(Line(points = {{-44, -79}, {-64, -79}, {-64, -80}, {-64, -80}}, color = {0, 0, 127}));
    connect(OutflowValve.bloodFlowInflow, BackflowConductor.Outflow) annotation(Line(points = {{-67, 67}, {-68, 67}, {-68, -66}, {-58, -66}}));
    connect(OutflowResistor.Inflow, OutflowValve.bloodFlowOutflow) annotation(Line(points = {{30, 67}, {-38, 67}}));
    connect(Outflow, OutflowResistor.Outflow) annotation(Line(points = {{92, 0}, {60, 0}, {60, 67}}));
    connect(BackflowValve.bloodFlowInflow, OutflowResistor.Outflow) annotation(Line(points = {{60, -66}, {60, 67}}));
    connect(BackflowConductor.Inflow, BackflowValve.bloodFlowOutflow) annotation(Line(points = {{-30, -66}, {30, -66}}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {-53, -56}, extent = {{111, 28}, {-1, 0}}, textString = "%name"), Polygon(origin = {0, 10}, fillColor = {255, 85, 0}, fillPattern = FillPattern.Solid, points = {{-80, 70}, {-80, -70}, {80, 70}, {80, -70}, {-80, 70}}), Text(origin = {-57, 13}, extent = {{-19, 41}, {19, -41}}, textString = "C"), Text(origin = {55, 14}, extent = {{-19, 32}, {19, -32}}, textString = "V"), Text(origin = {58, 84}, lineColor = {18, 232, 7}, fillColor = {30, 222, 20}, extent = {{-10, 14}, {10, -14}}, textString = "CR"), Text(origin = {-54, 88}, lineColor = {232, 206, 4}, fillColor = {219, 222, 26}, extent = {{-10, 14}, {10, -14}}, textString = "RR")}));
  end CardiacValve;

  model HeartIntervals
    Boolean b;
    discrete Real HP;
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
    BloodElasticCompartment RightAtrium(V0 = 149) annotation(Placement(visible = true, transformation(origin = {-50, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodElasticCompartment RightVentricle(V0 = 143) annotation(Placement(visible = true, transformation(origin = {48, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    CardiacValve tricuspidValve annotation(Placement(visible = true, transformation(origin = {-12, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RRAOUT(k = 0.003) annotation(Placement(visible = true, transformation(origin = {-22, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant CRABackflow(k = 0) annotation(Placement(visible = true, transformation(origin = {16, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    CardiacValve pulmonicValve annotation(Placement(visible = true, transformation(origin = {78, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RRV(k = 0.003) annotation(Placement(visible = true, transformation(origin = {66, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant CRVBackflow(k = 0) annotation(Placement(visible = true, transformation(origin = {96, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant VRAU(k = 30) annotation(Placement(visible = true, transformation(origin = {-90, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    AtrialElastance rightAtrialElastance(EMIN = 0.05, EMAX = 0.06) annotation(Placement(visible = true, transformation(origin = {-48, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant VRVU(k = 40) annotation(Placement(visible = true, transformation(origin = {-3, -21}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
    VentricularElastance ventricularElastance1(EMIN = 0.057, EMAX = 0.49) annotation(Placement(visible = true, transformation(origin = {28, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput PTH annotation(Placement(visible = true, transformation(origin = {82, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {70, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput T0 annotation(Placement(visible = true, transformation(origin = {-96, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tvs annotation(Placement(visible = true, transformation(origin = {-98, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tav annotation(Placement(visible = true, transformation(origin = {-94, 60}, extent = {{-8, -8}, {8, 8}}, rotation = -90), iconTransformation(extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tas annotation(Placement(visible = true, transformation(origin = {6, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    BloodFlowInflow bloodFlowInflow1 annotation(Placement(visible = true, transformation(origin = {-94, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-108, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow bloodFlowOutflow1 annotation(Placement(visible = true, transformation(origin = {104, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(Tas, rightAtrialElastance.Tas) annotation(Line(points = {{6, 98}, {6, 80}, {-56, 80}, {-56, 72}, {-68, 72}, {-68, 58}, {-58, 58}}, color = {0, 0, 127}));
    connect(bloodFlowOutflow1, pulmonicValve.Outflow) annotation(Line(points = {{104, 32}, {103, 32}, {103, -44}, {86, -44}}));
    connect(Tas, ventricularElastance1.Tas) annotation(Line(points = {{6, 98}, {17, 98}, {17, 35}}, color = {0, 0, 127}));
    connect(Tvs, ventricularElastance1.Tvs) annotation(Line(points = {{-98, 36}, {1.5, 36}, {1.5, 26}, {17, 26}}, color = {0, 0, 127}));
    connect(T0, rightAtrialElastance.T0) annotation(Line(points = {{-96, 10}, {-57, 10}, {-57, 41}}, color = {0, 0, 127}));
    connect(T0, ventricularElastance1.T0) annotation(Line(points = {{-96, 10}, {-19.5, 10}, {-19.5, 22}, {17, 22}}, color = {0, 0, 127}));
    connect(PTH, RightAtrium.ExternalPressure) annotation(Line(points = {{82, 98}, {-50, 98}, {-50, -32}}, color = {0, 0, 127}));
    connect(PTH, RightVentricle.ExternalPressure) annotation(Line(points = {{82, 98}, {48, 98}, {48, -32}}, color = {0, 0, 127}));
    connect(Tav, ventricularElastance1.Tav) annotation(Line(points = {{-94, 60}, {6, 60}, {6, 30}, {16, 30}}, color = {0, 0, 127}));
    connect(ventricularElastance1.Et, RightVentricle.Elastance) annotation(Line(points = {{37, 35}, {56, 35}, {56, -36}}, color = {0, 0, 127}));
    connect(VRVU.y, RightVentricle.UnstressedVolume) annotation(Line(points = {{7, -21}, {7, -27.5}, {40, -27.5}, {40, -36}}, color = {0, 0, 127}));
    connect(rightAtrialElastance.Et, RightAtrium.Elastance) annotation(Line(points = {{-38, 50}, {-38, 49}, {-34, 49}, {-34, 44}, {-22, 44}, {-22, 6}, {-42, 6}, {-42, -36}}, color = {0, 0, 127}));
    connect(VRAU.y, RightAtrium.UnstressedVolume) annotation(Line(points = {{-79, -24}, {-58, -24}, {-58, -36}, {-58, -36}, {-58, -36}}, color = {0, 0, 127}));
    connect(tricuspidValve.RR, RRAOUT.y) annotation(Line(points = {{-20, -53}, {-22, -53}, {-22, -70}, {-22, -70}}, color = {0, 0, 127}));
    connect(tricuspidValve.CR, CRABackflow.y) annotation(Line(points = {{-4, -53}, {16, -53}, {16, -74}, {16, -74}}, color = {0, 0, 127}));
    connect(pulmonicValve.CR, CRVBackflow.y) annotation(Line(points = {{86, -53}, {96, -53}, {96, -70}, {96, -70}}, color = {0, 0, 127}));
    connect(pulmonicValve.RR, RRV.y) annotation(Line(points = {{70, -53}, {66, -53}, {66, -68}, {66, -68}, {66, -68}}, color = {0, 0, 127}));
    connect(pulmonicValve.Inflow, RightVentricle.Outflow) annotation(Line(points = {{69, -44}, {58, -44}, {58, -44}, {58, -44}}));
    connect(RightVentricle.Inflow, tricuspidValve.Outflow) annotation(Line(points = {{39, -44}, {-4, -44}, {-4, -44}, {-4, -44}}));
    connect(RightAtrium.Outflow, tricuspidValve.Inflow) annotation(Line(points = {{-41, -44}, {-22, -44}, {-22, -44}, {-22, -44}}));
    connect(RightAtrium.Inflow, bloodFlowInflow1) annotation(Line(points = {{-59, -44}, {-94, -44}, {-94, -50}}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {-46, -26}, lineColor = {0, 255, 0}, extent = {{-12, -10}, {12, 10}}, textString = "T0"), Text(origin = {-47, 29}, lineColor = {85, 170, 255}, extent = {{-11, -13}, {11, 13}}, textString = "Tvs"), Text(origin = {-59, 78}, lineColor = {255, 85, 0}, extent = {{-9, -10}, {9, 10}}, textString = "Tav"), Text(origin = {88, 59}, extent = {{-10, 13}, {10, -13}}, textString = "PTH"), Text(origin = {13, 76}, lineColor = {0, 0, 127}, extent = {{-9, 10}, {13, -16}}, textString = "Tas"), Polygon(origin = {34.98, -24.02}, lineColor = {255, 0, 0}, fillColor = {226, 0, 3}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, points = {{-52.9786, -55.9821}, {-64.9786, 4.01794}, {-26.9786, 72.0179}, {45.0214, 48.0179}, {65.0214, -5.98206}, {37.0214, -71.9821}, {-52.9786, -55.9821}, {-52.9786, -55.9821}}), Text(origin = {35, -21}, extent = {{33, -63}, {-33, 63}}, textString = "RightHeart")}));
  end RightHeart;

  model LeftHeart
    BloodElasticCompartment LeftAtrium(V0 = 89) annotation(Placement(visible = true, transformation(origin = {-50, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodElasticCompartment LeftVentricle(V0 = 138) annotation(Placement(visible = true, transformation(origin = {48, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    CardiacValve tricuspidValve annotation(Placement(visible = true, transformation(origin = {-12, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RLAOUT(k = 0.003) annotation(Placement(visible = true, transformation(origin = {-22, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant CLABackflow(k = 0) annotation(Placement(visible = true, transformation(origin = {16, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    CardiacValve pulmonicValve annotation(Placement(visible = true, transformation(origin = {78, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RLV(k = 0.003) annotation(Placement(visible = true, transformation(origin = {66, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant CLVBackflow(k = 0) annotation(Placement(visible = true, transformation(origin = {96, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant VLAU(k = 30) annotation(Placement(visible = true, transformation(origin = {-90, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    AtrialElastance rightAtrialElastance(EMIN = 0.12, EMAX = 0.28) annotation(Placement(visible = true, transformation(origin = {-48, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant VLVU(k = 60) annotation(Placement(visible = true, transformation(origin = {-3, -21}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
    VentricularElastance ventricularElastance1(EMIN = 0.09, EMAX = 4) annotation(Placement(visible = true, transformation(origin = {28, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput PTH annotation(Placement(visible = true, transformation(origin = {86, 96}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {70, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput Tvs annotation(Placement(visible = true, transformation(origin = {-90, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tav annotation(Placement(visible = true, transformation(origin = {-92, 50}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-84, 52}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput Tas annotation(Placement(visible = true, transformation(origin = {-80, 92}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 88}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput T0 annotation(Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    BloodFlowInflow bloodFlowInflow1 annotation(Placement(visible = true, transformation(origin = {-94, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-108, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow bloodFlowOutflow1 annotation(Placement(visible = true, transformation(origin = {112, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(T0, ventricularElastance1.T0) annotation(Line(points = {{-100, 0}, {-38.5, 0}, {-38.5, 22}, {17, 22}}, color = {0, 0, 127}));
    connect(T0, rightAtrialElastance.T0) annotation(Line(points = {{-100, 0}, {-57, 0}, {-57, 41}}, color = {0, 0, 127}));
    connect(Tav, ventricularElastance1.Tav) annotation(Line(points = {{-92, 50}, {6, 50}, {6, 30}, {16, 30}}, color = {0, 0, 127}));
    connect(Tvs, ventricularElastance1.Tvs) annotation(Line(points = {{-90, 26}, {17, 26}}, color = {0, 0, 127}));
    connect(PTH, LeftAtrium.ExternalPressure) annotation(Line(points = {{86, 96}, {-50, 96}, {-50, -32}}, color = {0, 0, 127}));
    connect(PTH, LeftVentricle.ExternalPressure) annotation(Line(points = {{86, 96}, {48, 96}, {48, -32}}, color = {0, 0, 127}));
    connect(ventricularElastance1.Et, LeftVentricle.Elastance) annotation(Line(points = {{37, 35}, {56, 35}, {56, -36}}, color = {0, 0, 127}));
    connect(Tas, ventricularElastance1.Tas) annotation(Line(points = {{-80, 92}, {17, 92}, {17, 35}}, color = {0, 0, 127}));
    connect(Tas, rightAtrialElastance.Tas) annotation(Line(points = {{-80, 92}, {-58, 92}, {-58, 58}}, color = {0, 0, 127}));
    connect(VLVU.y, LeftVentricle.UnstressedVolume) annotation(Line(points = {{7, -21}, {7, -27.5}, {40, -27.5}, {40, -36}}, color = {0, 0, 127}));
    connect(rightAtrialElastance.Et, LeftAtrium.Elastance) annotation(Line(points = {{-38, 50}, {-38, 49}, {-34, 49}, {-34, 44}, {-22, 44}, {-22, 6}, {-42, 6}, {-42, -36}}, color = {0, 0, 127}));
    connect(VLAU.y, LeftAtrium.UnstressedVolume) annotation(Line(points = {{-79, -24}, {-58, -24}, {-58, -36}, {-58, -36}, {-58, -36}}, color = {0, 0, 127}));
    connect(tricuspidValve.RR, RLAOUT.y) annotation(Line(points = {{-20, -53}, {-22, -53}, {-22, -70}, {-22, -70}}, color = {0, 0, 127}));
    connect(tricuspidValve.CR, CLABackflow.y) annotation(Line(points = {{-4, -53}, {16, -53}, {16, -74}, {16, -74}}, color = {0, 0, 127}));
    connect(pulmonicValve.CR, CLVBackflow.y) annotation(Line(points = {{86, -53}, {96, -53}, {96, -70}, {96, -70}}, color = {0, 0, 127}));
    connect(pulmonicValve.RR, RLV.y) annotation(Line(points = {{70, -53}, {66, -53}, {66, -68}, {66, -68}, {66, -68}}, color = {0, 0, 127}));
    connect(bloodFlowOutflow1, pulmonicValve.Outflow) annotation(Line(points = {{112, -42}, {86, -42}, {86, -44}, {86, -44}}));
    connect(pulmonicValve.Inflow, LeftVentricle.Outflow) annotation(Line(points = {{69, -44}, {58, -44}, {58, -44}, {58, -44}}));
    connect(LeftVentricle.Inflow, tricuspidValve.Outflow) annotation(Line(points = {{39, -44}, {-4, -44}, {-4, -44}, {-4, -44}}));
    connect(LeftAtrium.Outflow, tricuspidValve.Inflow) annotation(Line(points = {{-41, -44}, {-22, -44}, {-22, -44}, {-22, -44}}));
    connect(LeftAtrium.Inflow, bloodFlowInflow1) annotation(Line(points = {{-59, -44}, {-94, -44}, {-94, -50}}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {-46, -26}, lineColor = {0, 255, 0}, extent = {{-12, -10}, {12, 10}}, textString = "T0"), Text(origin = {-45, 13}, lineColor = {85, 170, 255}, extent = {{-11, -13}, {11, 13}}, textString = "Tvs"), Text(origin = {-53, 50}, lineColor = {255, 85, 0}, extent = {{-9, -10}, {9, 10}}, textString = "Tav"), Text(origin = {88, 59}, extent = {{-10, 13}, {10, -13}}, textString = "PTH"), Text(origin = {-39, 88}, lineColor = {0, 0, 127}, extent = {{-9, 10}, {13, -16}}, textString = "Tas"), Polygon(origin = {34.98, -24.02}, rotation = -90, lineColor = {255, 0, 0}, fillColor = {226, 8, 179}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, points = {{-52.9786, -55.9821}, {-64.9786, 4.01794}, {-26.9786, 72.0179}, {45.0214, 48.0179}, {65.0214, -5.98206}, {37.0214, -71.9821}, {-52.9786, -55.9821}, {-52.9786, -55.9821}}), Text(origin = {35, -21}, extent = {{33, -63}, {-33, 63}}, textString = "LeftHeart")}));
  end LeftHeart;

  model SystemicArteries
    VariableBloodResistor ExtrathoracicArterialResistance annotation(Placement(visible = true, transformation(origin = {-18, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {-92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RETHA(k = 0.06) annotation(Placement(visible = true, transformation(origin = {-46, -30}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput IntrathoracicPressure annotation(Placement(visible = true, transformation(origin = {-78, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant LETHA(k = 0.0007) annotation(Placement(visible = true, transformation(origin = {16, 66}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant EITHA(k = 1.43) annotation(Placement(visible = true, transformation(origin = {38, 64}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant VITHAU(k = 140) annotation(Placement(visible = true, transformation(origin = {66, 68}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant EETHA(k = 0.556) annotation(Placement(visible = true, transformation(origin = {-80, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Pext(k = 0) annotation(Placement(visible = true, transformation(origin = {-84, 48}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant VETHAU(k = 370) annotation(Placement(visible = true, transformation(origin = {-56, 52}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    BloodElasticCompartment ExtrathoracicArteries(V0 = 519) annotation(Placement(visible = true, transformation(origin = {-50, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    BloodElasticCompartment IntrathoracicArteries(V0 = 201) annotation(Placement(visible = true, transformation(origin = {52, -4}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Inductor BloodFlouwInertia annotation(Placement(visible = true, transformation(origin = {18, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  equation
    connect(EETHA.y, ExtrathoracicArteries.Elastance) annotation(Line(points = {{-71, 22}, {-58, 22}, {-58, 6}, {-58, 6}}, color = {0, 0, 127}));
    connect(VETHAU.y, ExtrathoracicArteries.UnstressedVolume) annotation(Line(points = {{-47, 52}, {-42, 52}, {-42, 6}, {-42, 6}}, color = {0, 0, 127}));
    connect(IntrathoracicArteries.Elastance, EITHA.y) annotation(Line(points = {{44, 4}, {38, 4}, {38, 56}, {38, 56}}, color = {0, 0, 127}));
    connect(IntrathoracicArteries.UnstressedVolume, VITHAU.y) annotation(Line(points = {{60, 4}, {66, 4}, {66, 60}, {66, 60}}, color = {0, 0, 127}));
    connect(IntrathoracicArteries.Inflow, Inflow) annotation(Line(points = {{61, -4}, {86, -4}, {86, -2}, {86, -2}}));
    connect(IntrathoracicArteries.Outflow, BloodFlouwInertia.Inflow) annotation(Line(points = {{43, -4}, {26, -4}, {26, -2}, {26, -2}}));
    connect(BloodFlouwInertia.Outflow, ExtrathoracicArterialResistance.Inflow) annotation(Line(points = {{9, -2}, {-8, -2}, {-8, -2}, {-8, -2}}));
    connect(ExtrathoracicArterialResistance.Outflow, ExtrathoracicArteries.Inflow) annotation(Line(points = {{-27, -2}, {-42, -2}, {-42, -2}, {-42, -2}}));
    connect(ExtrathoracicArteries.Outflow, Outflow) annotation(Line(points = {{-59, -2}, {-84, -2}, {-84, -4}, {-84, -4}}));
    connect(LETHA.y, BloodFlouwInertia.Inertance) annotation(Line(points = {{16, 57}, {18, 57}, {18, 6}}, color = {0, 0, 127}));
    connect(IntrathoracicArteries.ExternalPressure, IntrathoracicPressure) annotation(Line(points = {{52, 8}, {50, 8}, {50, 82}, {-70, 82}}, color = {0, 0, 127}));
    connect(ExtrathoracicArteries.ExternalPressure, Pext.y) annotation(Line(points = {{-50, 10}, {-50, 35.5}, {-75, 35.5}, {-75, 48}}, color = {0, 0, 127}));
    connect(RETHA.y, ExtrathoracicArterialResistance.BloodResistance) annotation(Line(points = {{-37, -30}, {-18, -30}, {-18, -12}, {-18, -12}}, color = {0, 0, 127}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {5, -12}, fillColor = {240, 32, 13}, fillPattern = FillPattern.Solid, extent = {{-89, 84}, {89, -84}}), Ellipse(origin = {-85, -10}, fillColor = {41, 9, 199}, fillPattern = FillPattern.Solid, extent = {{-7, 84}, {7, -84}}, endAngle = 360), Text(origin = {0, 41}, extent = {{-56, 15}, {56, -15}}, textString = "intrathoracic pressure"), Text(origin = {2, -70}, extent = {{-62, 18}, {62, -18}}, textString = "%name")}));
  end SystemicArteries;

  model SystemicPeripheralVessels
    Modelica.Blocks.Sources.Constant EET(k = 0.262) annotation(Placement(visible = true, transformation(origin = {-26, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RTA(k = 0.2) annotation(Placement(visible = true, transformation(origin = {-70, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant TUV(k = 185) annotation(Placement(visible = true, transformation(origin = {26, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
    Modelica.Blocks.Sources.Constant Pext(k = 0) annotation(Placement(visible = true, transformation(origin = {0, 58}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput PeripheralArteriolarResistance annotation(Placement(visible = true, transformation(origin = {78, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-1, 67}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
    BloodFlowOutflow bloodFlowOutflow annotation(Placement(visible = true, transformation(origin = {-89, -5}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    VariableBloodResistor SmallVenuleResistances annotation(Placement(visible = true, transformation(origin = {-57, -5}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
    BloodElasticCompartment BloodTissueElasticCompartment(V0 = 281) annotation(Placement(visible = true, transformation(origin = {1, -5}, extent = {{21, -21}, {-21, 21}}, rotation = 0)));
    VariableBloodResistor SystemicArteriolaResistance annotation(Placement(visible = true, transformation(origin = {52, -4}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));
    BloodFlowInflow bloodFlowInflow annotation(Placement(visible = true, transformation(origin = {83, -5}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(TUV.y, BloodTissueElasticCompartment.UnstressedVolume) annotation(Line(points = {{17, 38}, {18, 38}, {18, 12}, {18, 12}}, color = {0, 0, 127}));
    connect(EET.y, BloodTissueElasticCompartment.Elastance) annotation(Line(points = {{-17, 38}, {-14, 38}, {-14, 12}, {-14, 12}}, color = {0, 0, 127}));
    connect(BloodTissueElasticCompartment.Outflow, SmallVenuleResistances.Inflow) annotation(Line(points = {{-19, -5}, {-48, -5}, {-48, -6}, {-48, -6}}));
    connect(SystemicArteriolaResistance.Outflow, BloodTissueElasticCompartment.Inflow) annotation(Line(points = {{41, -4}, {20, -4}, {20, -6}, {20, -6}}));
    connect(SystemicArteriolaResistance.Inflow, bloodFlowInflow) annotation(Line(points = {{63, -4}, {71.5, -4}, {71.5, -5}, {83, -5}}));
    connect(PeripheralArteriolarResistance, SystemicArteriolaResistance.BloodResistance) annotation(Line(points = {{78, 60}, {52, 60}, {52, 3}}, color = {0, 0, 127}));
    connect(BloodTissueElasticCompartment.ExternalPressure, Pext.y) annotation(Line(points = {{1, 19}, {0, 19}, {0, 50}}, color = {0, 0, 127}));
    connect(SmallVenuleResistances.Outflow, bloodFlowOutflow) annotation(Line(points = {{-67, -5}, {-89, -5}}));
    connect(RTA.y, SmallVenuleResistances.BloodResistance) annotation(Line(points = {{-61, 38}, {-57, 38}, {-57, 2}}, color = {0, 0, 127}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(origin = {1, -5}, lineColor = {240, 0, 0}, lineThickness = 1, extent = {{-85, 69}, {85, -69}}, endAngle = 360), Ellipse(origin = {-1, 0}, lineColor = {240, 0, 0}, lineThickness = 1, extent = {{-85, -12}, {85, 12}}, endAngle = 360), Ellipse(origin = {2, -1}, lineColor = {240, 0, 0}, lineThickness = 1, extent = {{-86, -19}, {86, 19}}, endAngle = 360), Text(origin = {-28, -37}, extent = {{54, -21}, {-2, 1}}, textString = "%name"), Text(origin = {-27, 42}, extent = {{75, -20}, {-3, 2}}, textString = "peripheral Resistance")}));
  end SystemicPeripheralVessels;

  model SystemicVeins
    Modelica.Blocks.Sources.Constant Pext(k = 0) annotation(Placement(visible = true, transformation(origin = {58, 58}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput IntrathoracicPressure annotation(Placement(visible = true, transformation(origin = {-82, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-1, 43}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant VITHVU(k = 1190) annotation(Placement(visible = true, transformation(origin = {-10, 62}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant EITHV(k = 0.0182) annotation(Placement(visible = true, transformation(origin = {-48, 48}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant VETHVU(k = 1000) annotation(Placement(visible = true, transformation(origin = {82, 56}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant EETHV(k = 0.0169) annotation(Placement(visible = true, transformation(origin = {30, 56}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant RETHV(k = 0.09) annotation(Placement(visible = true, transformation(origin = {16, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));
    Modelica.Blocks.Sources.Constant RRAIN(k = 0.003) annotation(Placement(visible = true, transformation(origin = {-60, -48}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));
    VariableBloodResistor VeinsResistance annotation(Placement(visible = true, transformation(origin = {16, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    VariableBloodResistor centralVenousResistance annotation(Placement(visible = true, transformation(origin = {-60, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {90, -12}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-96, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {-86, -12}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {92, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodElasticCompartment intrathoracicVeins(V0 = 1523) annotation(Placement(visible = true, transformation(origin = {-22, -12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    BloodElasticCompartment extrathoracicVeins(V0 = 1546) annotation(Placement(visible = true, transformation(origin = {60, -12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  equation
    connect(extrathoracicVeins.Inflow, Inflow) annotation(Line(points = {{69, -12}, {90, -12}}));
    connect(extrathoracicVeins.Outflow, VeinsResistance.Inflow) annotation(Line(points = {{51, -12}, {25, -12}}));
    connect(EETHV.y, extrathoracicVeins.Elastance) annotation(Line(points = {{30, 47}, {52, 47}, {52, -4}}, color = {0, 0, 127}));
    connect(VETHVU.y, extrathoracicVeins.UnstressedVolume) annotation(Line(points = {{82, 47}, {68, 47}, {68, -4}}, color = {0, 0, 127}));
    connect(extrathoracicVeins.ExternalPressure, Pext.y) annotation(Line(points = {{60, 0}, {60, 27.5}, {58, 27.5}, {58, 49}}, color = {0, 0, 127}));
    connect(centralVenousResistance.Inflow, intrathoracicVeins.Outflow) annotation(Line(points = {{-51, -12}, {-30, -12}, {-30, -12}, {-30, -12}}));
    connect(intrathoracicVeins.Inflow, VeinsResistance.Outflow) annotation(Line(points = {{-13, -12}, {8, -12}, {8, -12}, {8, -12}}));
    connect(intrathoracicVeins.UnstressedVolume, VITHVU.y) annotation(Line(points = {{-14, -4}, {-14, 50}, {-10, 50}, {-10, 53}}, color = {0, 0, 127}));
    connect(EITHV.y, intrathoracicVeins.Elastance) annotation(Line(points = {{-39, 48}, {-30, 48}, {-30, -4}}, color = {0, 0, 127}));
    connect(IntrathoracicPressure, intrathoracicVeins.ExternalPressure) annotation(Line(points = {{-82, 80}, {-22, 80}, {-22, 0}}, color = {0, 0, 127}));
    connect(centralVenousResistance.Outflow, Outflow) annotation(Line(points = {{-69, -12}, {-86, -12}}));
    connect(RRAIN.y, centralVenousResistance.BloodResistance) annotation(Line(points = {{-60, -39.2}, {-60, -20.2}}, color = {0, 0, 127}));
    connect(RETHV.y, VeinsResistance.BloodResistance) annotation(Line(points = {{16, -31.2}, {16, -22.2}}, color = {0, 0, 127}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {-4, 4}, lineColor = {0, 85, 255}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-78, 42}, {78, -42}}), Text(origin = {2, 18}, extent = {{-72, 8}, {72, -8}}, textString = "intrathoracic pressure"), Ellipse(origin = {-83, 4}, fillColor = {0, 85, 127}, fillPattern = FillPattern.Solid, extent = {{9, 40}, {-9, -40}}, endAngle = 360), Text(origin = {-5, -19}, extent = {{-33, 11}, {33, -11}}, textString = "%name")}));
  end SystemicVeins;

  model PulmonaryCirculation
    BloodElasticCompartment PulmonaryVeins(V0 = 508) annotation(Placement(visible = true, transformation(origin = {10, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodElasticCompartment pULMONARYaRTERIES(V0 = 103) annotation(Placement(visible = true, transformation(origin = {-60, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RLAIN(k = 0.003) annotation(Placement(visible = true, transformation(origin = {32, -26}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RPP(k = 0.11) annotation(Placement(visible = true, transformation(origin = {-48, -26}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    BloodFlowOutflow Outflow annotation(Placement(visible = true, transformation(origin = {78, 6}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BloodFlowInflow Inflow annotation(Placement(visible = true, transformation(origin = {-88, 6}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-92, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant VPAU(k = 50) annotation(Placement(visible = true, transformation(origin = {-72, 46}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant EPA(k = 0.233) annotation(Placement(visible = true, transformation(origin = {-44, 52}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant VPVU(k = 350) annotation(Placement(visible = true, transformation(origin = {-2, 50}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant EPV(k = 0.0455) annotation(Placement(visible = true, transformation(origin = {22, 52}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput IntrathoracicPressure annotation(Placement(visible = true, transformation(origin = {-100, 84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-5, 53}, extent = {{-17, -17}, {17, 17}}, rotation = -90)));
    VariableBloodResistor PulmonaryVeinResistance annotation(Placement(visible = true, transformation(origin = {52, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    VariableBloodResistor PulmonaryArteriesResistance annotation(Placement(visible = true, transformation(origin = {-28, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  equation
    connect(PulmonaryArteriesResistance.Outflow, PulmonaryVeins.Inflow) annotation(Line(points = {{-19, 6}, {2, 6}, {2, 6}, {2, 6}}));
    connect(pULMONARYaRTERIES.Outflow, PulmonaryArteriesResistance.Inflow) annotation(Line(points = {{-51, 6}, {-36, 6}, {-36, 6}, {-36, 6}}));
    connect(RPP.y, PulmonaryArteriesResistance.BloodResistance) annotation(Line(points = {{-39, -26}, {-28, -26}, {-28, 0}}, color = {0, 0, 127}));
    connect(PulmonaryVeinResistance.Outflow, Outflow) annotation(Line(points = {{61, 6}, {74, 6}, {74, 6}, {74, 6}}));
    connect(PulmonaryVeins.Outflow, PulmonaryVeinResistance.Inflow) annotation(Line(points = {{19, 6}, {44, 6}, {44, 6}, {44, 6}}));
    connect(RLAIN.y, PulmonaryVeinResistance.BloodResistance) annotation(Line(points = {{41, -26}, {52, -26}, {52, 0}}, color = {0, 0, 127}));
    connect(EPV.y, PulmonaryVeins.Elastance) annotation(Line(points = {{22, 43}, {18, 43}, {18, 14}}, color = {0, 0, 127}));
    connect(VPVU.y, PulmonaryVeins.UnstressedVolume) annotation(Line(points = {{-2, 41}, {2, 41}, {2, 14}}, color = {0, 0, 127}));
    connect(EPA.y, pULMONARYaRTERIES.Elastance) annotation(Line(points = {{-44, 43}, {-52, 43}, {-52, 14}}, color = {0, 0, 127}));
    connect(VPAU.y, pULMONARYaRTERIES.UnstressedVolume) annotation(Line(points = {{-72, 37}, {-68, 37}, {-68, 14}}, color = {0, 0, 127}));
    connect(IntrathoracicPressure, PulmonaryVeins.ExternalPressure) annotation(Line(points = {{-100, 84}, {10, 84}, {10, 18}}, color = {0, 0, 127}));
    connect(IntrathoracicPressure, pULMONARYaRTERIES.ExternalPressure) annotation(Line(points = {{-100, 84}, {-60, 84}, {-60, 18}}, color = {0, 0, 127}));
    connect(pULMONARYaRTERIES.Inflow, Inflow) annotation(Line(points = {{-69, 6}, {-88, 6}}));
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {-8, 7}, fillColor = {255, 170, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-74, 41}, {74, -41}}), Ellipse(origin = {-83, 4}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{9, 40}, {-9, -40}}, endAngle = 360), Text(origin = {0, 28}, extent = {{-72, 8}, {72, -8}}, textString = "intrathoracic pressure"), Text(origin = {-24, 4}, extent = {{-30, 8}, {54, -24}}, textString = "%name")}));
  end PulmonaryCirculation;

  model HemoDynamics
    LeftHeart leftHeart1 annotation(Placement(visible = true, transformation(origin = {70, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant HeartRate(k = 72) annotation(Placement(visible = true, transformation(origin = {-80, 84}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
    HeartIntervals heartIntervals1 annotation(Placement(visible = true, transformation(origin = {-75, 53}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant PTH(k = -4) annotation(Placement(visible = true, transformation(origin = {-88, 22}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    RightHeart rightHeart1 annotation(Placement(visible = true, transformation(origin = {-23, 17}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
    SystemicPeripheralVessels systemicPeripheralVessels annotation(Placement(visible = true, transformation(origin = {-3, -65}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
    SystemicArteries systemicArteries annotation(Placement(visible = true, transformation(origin = {67, -65}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant RSP(k = 0.8) annotation(Placement(visible = true, transformation(origin = {-43, -47}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    PulmonaryCirculation pulmonaryCirculation annotation(Placement(visible = true, transformation(origin = {33, -15}, extent = {{-17, 17}, {17, -17}}, rotation = 0)));
    SystemicVeins systemicVeins annotation(Placement(visible = true, transformation(origin = {-68, -68}, extent = {{18, -18}, {-18, 18}}, rotation = 0)));
  equation
    connect(systemicVeins.Outflow, rightHeart1.bloodFlowInflow1) annotation(Line(points = {{-85, -67}, {-90, -67}, {-90, 4}, {-46, 4}}));
    connect(systemicPeripheralVessels.bloodFlowOutflow, systemicVeins.Inflow) annotation(Line(points = {{-24, -65}, {-38.5, -65}, {-38.5, -67}, {-51, -67}}));
    connect(systemicVeins.IntrathoracicPressure, PTH.y) annotation(Line(points = {{-68, -60}, {-68, 22}, {-80, 22}}, color = {0, 0, 127}));
    connect(rightHeart1.bloodFlowOutflow1, pulmonaryCirculation.Inflow) annotation(Line(points = {{0, 20}, {6, 20}, {6, -16}, {18, -16}, {18, -16}}));
    connect(pulmonaryCirculation.Outflow, leftHeart1.bloodFlowInflow1) annotation(Line(points = {{46, -16}, {46, 6}, {48, 6}}));
    connect(pulmonaryCirculation.IntrathoracicPressure, PTH.y) annotation(Line(points = {{32, -24}, {-76, -24}, {-76, 22}, {-80, 22}}, color = {0, 0, 127}));
    connect(leftHeart1.bloodFlowOutflow1, systemicArteries.Inflow) annotation(Line(points = {{92, 6}, {98, 6}, {98, -66}, {84, -66}, {84, -66}, {84, -66}}));
    connect(RSP.y, systemicPeripheralVessels.PeripheralArteriolarResistance) annotation(Line(points = {{-35, -47}, {-3, -47}, {-3, -50}}, color = {0, 0, 127}));
    connect(systemicArteries.IntrathoracicPressure, PTH.y) annotation(Line(points = {{67, -50}, {67, -36}, {-72, -36}, {-72, 22}, {-80, 22}}, color = {0, 0, 127}));
    connect(systemicPeripheralVessels.bloodFlowInflow, systemicArteries.Outflow) annotation(Line(points = {{18, -65}, {50, -65}}));
    connect(PTH.y, rightHeart1.PTH) annotation(Line(points = {{-80, 22}, {-54, 22}, {-54, 94}, {-8, 94}, {-8, 34}}, color = {0, 0, 127}));
    connect(heartIntervals1.T0, rightHeart1.T0) annotation(Line(points = {{-59, 38}, {-60, 38}, {-60, 11}, {-40, 11}}, color = {0, 0, 127}));
    connect(heartIntervals1.Tvs, rightHeart1.Tvs) annotation(Line(points = {{-59, 49}, {-50, 49}, {-50, 25}, {-44, 25}}, color = {0, 0, 127}));
    connect(heartIntervals1.Tav, rightHeart1.Tav) annotation(Line(points = {{-59, 59}, {-43, 59}, {-43, 30}}, color = {0, 0, 127}));
    connect(heartIntervals1.Tas, rightHeart1.Tas) annotation(Line(points = {{-60, 68}, {-22, 68}, {-22, 38}}, color = {0, 0, 127}));
    connect(PTH.y, leftHeart1.PTH) annotation(Line(points = {{-80, 22}, {-54, 22}, {-54, 90}, {84, 90}, {84, 36}, {84, 36}, {84, 36}}, color = {0, 0, 127}));
    connect(heartIntervals1.T0, leftHeart1.T0) annotation(Line(points = {{-59, 38}, {-46, 38}, {-46, 54}, {12, 54}, {12, 18}, {44, 18}, {44, 12}, {52, 12}, {52, 12}}, color = {0, 0, 127}));
    connect(heartIntervals1.Tvs, leftHeart1.Tvs) annotation(Line(points = {{-59, 49}, {24, 49}, {24, 22}, {52, 22}, {52, 22}}, color = {0, 0, 127}));
    connect(heartIntervals1.Tav, leftHeart1.Tav) annotation(Line(points = {{-59, 59}, {34, 59}, {34, 28}, {52, 28}, {52, 28}}, color = {0, 0, 127}));
    connect(heartIntervals1.Tas, leftHeart1.Tas) annotation(Line(points = {{-60, 68}, {54, 68}, {54, 36}}, color = {0, 0, 127}));
    connect(HeartRate.y, heartIntervals1.HR) annotation(Line(points = {{-80, 76}, {-80, 65.5}, {-90, 65.5}, {-90, 55}}, color = {0, 0, 127}));
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end HemoDynamics;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end MOS_CV4;