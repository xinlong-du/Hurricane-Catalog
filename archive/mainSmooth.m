clear;clc;
NE1_NYR1_Sim1_0km=load('.\windRecords\NYRSimHurV4_NE1_NYR1_Sim1_0km.txt');
NE1_NYR1_Sim1_50km=load('.\windRecords\NYRSimHurV4_NE1_NYR1_Sim1_50km.txt');
NE1_NYR1_Sim1_100km=load('.\windRecords\NYRSimHurV4_NE1_NYR1_Sim1_100km.txt');
NE1_NYR1_Sim1_150km=load('.\windRecords\NYRSimHurV4_NE1_NYR1_Sim1_150km.txt');

NE1_NYR2_Sim2_0km=load('.\windRecords\NYRSimHurV4_NE1_NYR2_Sim2_0km.txt');
NE1_NYR2_Sim2_50km=load('.\windRecords\NYRSimHurV4_NE1_NYR2_Sim2_50km.txt');
NE1_NYR2_Sim2_100km=load('.\windRecords\NYRSimHurV4_NE1_NYR2_Sim2_100km.txt');
NE1_NYR2_Sim2_150km=load('.\windRecords\NYRSimHurV4_NE1_NYR2_Sim2_150km.txt');

NE2_NYR1_Sim1_0km=load('.\windRecords\NYRSimHurV4_NE2_NYR1_Sim1_0km.txt');
NE2_NYR1_Sim1_50km=load('.\windRecords\NYRSimHurV4_NE2_NYR1_Sim1_50km.txt');
NE2_NYR1_Sim1_100km=load('.\windRecords\NYRSimHurV4_NE2_NYR1_Sim1_100km.txt');
NE2_NYR1_Sim1_150km=load('.\windRecords\NYRSimHurV4_NE2_NYR1_Sim1_150km.txt');

NE7_NYR2_Sim1_0km=load('.\windRecords\NYRSimHurV4_NE7_NYR2_Sim1_0km.txt');
NE7_NYR2_Sim1_50km=load('.\windRecords\NYRSimHurV4_NE7_NYR2_Sim1_50km.txt');
NE7_NYR2_Sim1_100km=load('.\windRecords\NYRSimHurV4_NE7_NYR2_Sim1_100km.txt');
NE7_NYR2_Sim1_150km=load('.\windRecords\NYRSimHurV4_NE7_NYR2_Sim1_150km.txt');

NE9_NYR1_Sim3_0km=load('.\windRecords\NYRSimHurV4_NE9_NYR1_Sim3_0km.txt');
NE9_NYR1_Sim3_50km=load('.\windRecords\NYRSimHurV4_NE9_NYR1_Sim3_50km.txt');
NE9_NYR1_Sim3_100km=load('.\windRecords\NYRSimHurV4_NE9_NYR1_Sim3_100km.txt');
NE9_NYR1_Sim3_150km=load('.\windRecords\NYRSimHurV4_NE9_NYR1_Sim3_150km.txt');

smoothRecord(NE1_NYR1_Sim1_0km,'NE1_NYR1_Sim1_0km.txt')
smoothRecord(NE1_NYR1_Sim1_50km,'NE1_NYR1_Sim1_50km.txt')
smoothRecord(NE1_NYR1_Sim1_100km,'NE1_NYR1_Sim1_100km.txt')
smoothRecord(NE1_NYR1_Sim1_150km,'NE1_NYR1_Sim1_150km.txt')

smoothRecord(NE1_NYR2_Sim2_0km,'NE1_NYR2_Sim2_0km.txt')
smoothRecord(NE1_NYR2_Sim2_50km,'NE1_NYR2_Sim2_50km.txt')
smoothRecord(NE1_NYR2_Sim2_100km,'NE1_NYR2_Sim2_100km.txt')
smoothRecord(NE1_NYR2_Sim2_150km,'NE1_NYR2_Sim2_150km.txt')

smoothRecord(NE2_NYR1_Sim1_0km,'NE2_NYR1_Sim1_0km.txt')
smoothRecord(NE2_NYR1_Sim1_50km,'NE2_NYR1_Sim1_50km.txt')
smoothRecord(NE2_NYR1_Sim1_100km,'NE2_NYR1_Sim1_100km.txt')
smoothRecord(NE2_NYR1_Sim1_150km,'NE2_NYR1_Sim1_150km.txt')

smoothRecord(NE7_NYR2_Sim1_0km,'NE7_NYR2_Sim1_0km.txt')
smoothRecord(NE7_NYR2_Sim1_50km,'NE7_NYR2_Sim1_50km.txt')
smoothRecord(NE7_NYR2_Sim1_100km,'NE7_NYR2_Sim1_100km.txt')
smoothRecord(NE7_NYR2_Sim1_150km,'NE7_NYR2_Sim1_150km.txt')

smoothRecord(NE9_NYR1_Sim3_0km,'NE9_NYR1_Sim3_0km.txt')
smoothRecord(NE9_NYR1_Sim3_50km,'NE9_NYR1_Sim3_50km.txt')
smoothRecord(NE9_NYR1_Sim3_100km,'NE9_NYR1_Sim3_100km.txt')
smoothRecord(NE9_NYR1_Sim3_150km,'NE9_NYR1_Sim3_150km.txt')