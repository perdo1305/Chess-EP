
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
create_project: 2

00:00:092

00:00:092

1367.0902
8.9302
16732
12872Z17-722h px� 
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental /home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/Chess-EP.srcs/utils_1/imports/synth_1/vga_test.dcpZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2�
�/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/Chess-EP.srcs/utils_1/imports/synth_1/vga_test.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
c
Command: %s
53*	vivadotcl22
0synth_design -top vga_sync -part xc7a35tcpg236-1Z4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
z
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2	
xc7a35tZ17-347h px� 
j
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2	
xc7a35tZ17-349h px� 
D
Loading part %s157*device2
xc7a35tcpg236-1Z21-403h px� 
Z
$Part: %s does not have CEAM library.966*device2
xc7a35tcpg236-1Z21-9227h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
4Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
O
#Helper process launched with PID %s4824*oasys2
144524Z8-7075h px� 
�
%s*synth2�
�Starting RTL Elaboration : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 2119.812 ; gain = 411.746 ; free physical = 651 ; free virtual = 11848
h px� 
�
synthesizing module '%s'638*oasys2

vga_sync2k
g/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/vga_sync.vhd2
148@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2

vga_sync2
02
12k
g/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/vga_sync.vhd2
148@Z8-256h px� 
�
%s*synth2�
�Finished RTL Elaboration : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 2195.781 ; gain = 487.715 ; free physical = 551 ; free virtual = 11749
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 2210.625 ; gain = 502.559 ; free physical = 548 ; free virtual = 11745
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 2210.625 ; gain = 502.559 ; free physical = 548 ; free virtual = 11745
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2210.6252
0.0002
5482
11745Z17-722h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
Parsing XDC File [%s]
179*designutils2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc8Z20-179h px� 
�
No ports matched '%s'.
584*	planAhead2
	vgaRed[0]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1168@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1168@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
	vgaRed[1]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1178@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1178@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
	vgaRed[2]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1188@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1188@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
	vgaRed[3]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1198@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1198@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2

vgaBlue[0]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1208@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1208@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2

vgaBlue[1]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1218@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1218@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2

vgaBlue[2]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1228@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1228@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2

vgaBlue[3]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1238@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1238@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
vgaGreen[0]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1248@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1248@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
vgaGreen[1]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1258@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1258@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
vgaGreen[2]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1268@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1268@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
vgaGreen[3]2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1278@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1278@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
Hsync2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1288@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1288@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
Vsync2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1298@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
1298@Z17-55h px�
�
Finished Parsing XDC File [%s]
178*designutils2p
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2n
l/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/basys3_master.xdc2
.Xil/vga_sync_propImpl.xdcZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2346.3752
0.0002
5312
11731Z17-722h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
 Constraint Validation Runtime : 2

00:00:002

00:00:002

2346.3752
0.0002
5312
11731Z17-722h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:14 ; elapsed = 00:00:15 . Memory (MB): peak = 2346.375 ; gain = 638.309 ; free physical = 528 ; free virtual = 11726
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Loading part: xc7a35tcpg236-1
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:14 ; elapsed = 00:00:15 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 527 ; free virtual = 11725
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
%s
*synth20
.Start Applying 'set_property' XDC Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:14 ; elapsed = 00:00:15 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 520 ; free virtual = 11718
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
7
%s
*synth2
Start Preparing Guide Design
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
�The reference checkpoint %s is not suitable for use with incremental synthesis for this design. Please regenerate the checkpoint for this design with -incremental_synth switch in the same Vivado session that synth_design has been run. Synthesis will continue with the default flow4740*oasys2�
�/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/Chess-EP.srcs/utils_1/imports/synth_1/vga_test.dcpZ8-6895h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Doing Graph Differ : Time (s): cpu = 00:00:15 ; elapsed = 00:00:15 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 509 ; free virtual = 11708
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Preparing Guide Design : Time (s): cpu = 00:00:15 ; elapsed = 00:00:15 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 509 ; free virtual = 11708
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:15 ; elapsed = 00:00:15 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 517 ; free virtual = 11718
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
C
%s
*synth2+
)

Incremental Synthesis Report Summary:

h p
x
� 
<
%s
*synth2$
"1. Incremental synthesis run: no

h p
x
� 
O
%s
*synth27
5   Reason for not running incremental synthesis : 


h p
x
� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}4868*oasysZ8-7130h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
(
%s
*synth2
+---Adders : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit       Adders := 2     
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	               10 Bit    Registers := 2     
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 3     
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit        Muxes := 2     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
p
%s
*synth2X
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:16 ; elapsed = 00:00:17 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 512 ; free virtual = 11717
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
@
%s
*synth2(
&Start Applying XDC Timing Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:23 ; elapsed = 00:00:24 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 525 ; free virtual = 11730
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:23 ; elapsed = 00:00:24 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 517 ; free virtual = 11721
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:23 ; elapsed = 00:00:24 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 501 ; free virtual = 11705
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 515 ; free virtual = 11720
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 515 ; free virtual = 11720
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 514 ; free virtual = 11719
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 514 ; free virtual = 11719
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 514 ; free virtual = 11719
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 514 ; free virtual = 11719
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
| |BlackBox name |Instances |
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
0
%s*synth2
+------+-----+------+
h px� 
0
%s*synth2
|      |Cell |Count |
h px� 
0
%s*synth2
+------+-----+------+
h px� 
0
%s*synth2
|1     |BUFG |     1|
h px� 
0
%s*synth2
|2     |LUT1 |     1|
h px� 
0
%s*synth2
|3     |LUT2 |     3|
h px� 
0
%s*synth2
|4     |LUT3 |     5|
h px� 
0
%s*synth2
|5     |LUT4 |     4|
h px� 
0
%s*synth2
|6     |LUT5 |     4|
h px� 
0
%s*synth2
|7     |LUT6 |    26|
h px� 
0
%s*synth2
|8     |FDCE |    23|
h px� 
0
%s*synth2
|9     |IBUF |     2|
h px� 
0
%s*synth2
|10    |OBUF |    24|
h px� 
0
%s*synth2
+------+-----+------+
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.379 ; gain = 646.312 ; free physical = 513 ; free virtual = 11718
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
`
%s
*synth2H
FSynthesis finished with 0 errors, 1 critical warnings and 1 warnings.
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:26 ; elapsed = 00:00:26 . Memory (MB): peak = 2354.379 ; gain = 510.562 ; free physical = 491 ; free virtual = 11696
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:28 ; elapsed = 00:00:28 . Memory (MB): peak = 2354.387 ; gain = 646.312 ; free physical = 491 ; free virtual = 11696
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2354.3872
0.0002
4902
11695Z17-722h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2410.4062
0.0002
8342
12039Z17-722h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

bb293cd9Z4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
192
152
152
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
synth_design: 2

00:00:372

00:00:342

2410.4062

1036.3482
8342
12039Z17-722h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2

Physical2
PSS2=
;(MB): overall = 1978.209; main = 1617.508; forked = 455.488Z17-2834h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2	
Virtual2
VSS2>
<(MB): overall = 3480.074; main = 2410.410; forked = 1125.691Z17-2834h px� 
c
%s6*runtcl2G
ESynthesis results are not added to the cache due to CRITICAL_WARNING
h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.012

2434.4182
8.0042
8372
12044Z17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2
}/home/pedroferreira/Documents/3_ano_1_Semestre_EEC/Eletronica_Programavel/Project/Chess-EP/Chess-EP.runs/synth_1/vga_sync.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2[
Yreport_utilization -file vga_sync_utilization_synth.rpt -pb vga_sync_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Thu Nov 21 12:24:59 2024Z17-206h px� 


End Record