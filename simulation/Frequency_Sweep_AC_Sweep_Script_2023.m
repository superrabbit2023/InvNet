%% Information
% ==================================================================================================
% Yufei Li
% Princeton University
% yl5385@princeton.edu
% 
% Feburay 2023
% 
% ==================================================================================================
%% AC Sweep
%% Operating Points
%% PLL Bandwidth 50 Hz
clear
% load('Ydq50op171_bw100.mat', 'Ydq')
N=50;
fmin=1;
fmax=1e3;
VL_L=400;
VG_PEAK=VL_L/sqrt(3)*sqrt(2);
L=3e-3;
R=80e-3;
Vdc=700;
w=2*pi*50;
P0=30e3;
Q0=30e3;
ID0=P0/VL_L;
IQ0=Q0/VL_L;
% V, P, Q, Id, Iq
k=1;
for jv=0.9:0.1:1.1
    for jp=-1:0.5:1
        for jq=-1:0.5:1
            Vg_peak=jv*VG_PEAK; %voltage amplitude
            Vperturb=Vg_peak*1e-3;%voltage perturbation amplitude
            Vl_l=jv*VL_L; %line-to-line voltage
            P=jp*P0; %active power
            Q=jq*Q0; %reactive power
            Id=P/Vl_l; %d-axis current
            Iq=Q/Vl_l;  %q-axis current
            I=sqrt(Id^2+Iq^2);
            if (sqrt((Vg_peak+Id*R-Iq*w*L)^2+(Id*w*L)^2)<=Vdc/2&&I<1.1*ID0&&sqrt(Id^2+Iq^2)>0) %power constraints(restrictions)
                O(k,:)=[Vg_peak P Q];
                O1(k,:)=[jv jp jq];
                Ydq(k).V=O1(k,1);
                Ydq(k).P=O1(k,2);
                Ydq(k).Q=O1(k,3);
                for x=1:4
                    switch x
                        case 1
                            S1=0;
                            S2=0;%Defining the model as Ydd
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fdd=Y.F;
                            Ydq(k).f=Y.F;
                            Ydq(k).Y(:,1)=Y.G;
                        case 2
                            S1=0;
                            S2=1;%Defining the model as Ydq
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fdq=Y.F;
                            Ydq(k).Y(:,2)=Y.G;
                        case 3
                            S1=1;
                            S2=0;%Defining the model as Yqd
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fqd=Y.F;
                            Ydq(k).Y(:,3)=Y.G;
                        case 4
                            S1=1;
                            S2=1;%Defining the model as Yqq
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fqq=Y.F;
                            Ydq(k).Y(:,4)=Y.G;
                    end
                end
                save('Ydq50op24_PLL.mat','Ydq');
                k=k+1;
            end
        end
    end
end
save('Ydq50op24_PLL.mat','O1','O','Ydq');
% clear Yop
% for k=1:N
%     Yop(k).V=OP(k,1);
%     Yop(k).P=OP(k,2);
%     Yop(k).Q=OP(k,3);
%     Yop(k).f=f;
%     Yop(k).Y=GFL_Ydq_calc(f,OP(k,:)); % dq admittance calculation
% end

% % save('GFL_Ydq_5000_2Hz.mat','OP','Yop');
% save('GFL_Ydq_loglinear.mat','OP','Yop');
% 
% figure
% scatter3(OP(:,2),OP(:,3),OP(:,1),'filled')
% zlabel('V(p.u.)');
% xlabel('P(p.u.)');
% ylabel('Q(p.u.)');
% 
% N=length(OP(:,1));
% 
% % f=[1:2:500];
% N_f=199;
% step=(log10(5000)-log10(1))/N_f;
% f_power = [0:step:log10(5000)];
% f = 10.^f_power;


% f = [1:1:10 11:1:20 22:2:100 105:5:200 220:20:1000 1050:50:2000 2200:200:5000];

% delete k*50
% k=1;
% for j=1:length(f)
%     if (mod(f(j),50)==0)
%         k=k+1;
%     end
% end
% m=zeros(1,k-1);
% k=1;
% for j=1:length(f)
%     if (mod(f(j),50)==0)
%         m(k)=j;
%         k=k+1;
%     end
% end
% f(:,m)=[];

% clear Yop
% for k=1:N
%     Yop(k).V=OP(k,1);
%     Yop(k).P=OP(k,2);
%     Yop(k).Q=OP(k,3);
%     Yop(k).f=f;
%     Yop(k).Y=GFL_Ydq_calc(f,OP(k,:)); % dq admittance calculation
% end
% placsweep('ML_2L_GFL_Y_Measure_20211102/AC Sweep');
% clear Yop
% for k=1:N
%     Yop(k).V=OP(k,1);
%     Yop(k).P=OP(k,2);
%     Yop(k).Q=OP(k,3);
%     Yop(k).f=f;
%     Yop(k).Y=GFL_Ydq_calc(f,OP(k,:)); % dq admittance calculation
% end
% 
% % save('GFL_Ydq_5000_2Hz.mat','OP','Yop');
% save('GFL_Ydq_loglinear.mat','OP','Yop');

% %% plot one Yvsc
% f0=0;f1=5000;
% clear w1 Yvsc;
% for k=1:N
%     V=Yop(k).V;
%     P=Yop(k).P;
%     Q=Yop(k).Q;
%     if V<1.01 && V>0.99 % choose V=1
%         if P<1.01 && P>0.99 % choose P=1
%             if Q<0.01 && Q>-0.01 % choose Q=0
%                 w1=Yop(k).f;
%                 Yvsc=Yop(k).Y;
%                 figure
%                 set(gcf,'Position',[100 100 550 480]);%14
%
%                 %Yac11
%                 subplot 421
%                 h1=semilogx(w1,20*log10(abs(Yvsc(1,:))),'-');
%                 axis([f0 f1 -80 -20]);
%                 xticks([1 10 100 1000]);
%                 yticks([-80 -60 -40 -20 0]);
%                 title('Yac11','FontName','Times New Roman','FontSize',11);
%                 ylabel('Magnitude(dB)','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'xticklabel',[]);
%                 set(gca,'Position',[0.11 0.73 0.41 0.17]);%14
%                 subplot 423
%                 h1=semilogx(w1,phase(Yvsc(1,:))*180/pi,'-');
%                 axis([f0 f1 -1080 0]);
%                 xticks([1 10 100 1000]);
%                 yticks([-1080 -720  -360  0 360]);
%                 ylabel('Phase(deg)','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);%14,13,11
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'xticklabel',[]);
%                 set(gca,'Position',[0.11 0.53 0.41 0.17]);%14
%
%                 %Yac12
%                 subplot 422
%                 h1=semilogx(w1,20*log10(abs(Yvsc(2,:))),'-');
%                 axis([f0 f1 -80 -20]);
%                 xticks([1 10 100 1000]);
%                 yticks([-80 -60 -40 -20 0]);
%                 title('Yac12','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'xticklabel',[]);
%                 set(gca,'yticklabel',[]);
%                 set(gca,'Position',[0.56 0.73 0.41 0.17]);%14
%                 subplot 424
%                 h1=semilogx(w1,phase(Yvsc(2,:))*180/pi,'-');
%                 axis([f0 f1 -1080 0]);
%                 xticks([1 10 100 1000]);
%                 yticks([-1080 -720  -360  0 360]);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'xticklabel',[]);
%                 set(gca,'yticklabel',[]);
%                 set(gca,'Position',[0.56 0.53 0.41 0.17]);%14
%
%                 %Yac21
%                 subplot 425
%                 h1=semilogx(w1,20*log10(abs(Yvsc(3,:))),'-');
%                 axis([f0 f1 -80 -20]);
%                 xticks([1 10 100 1000]);
%                 yticks([-80 -60 -40 -20 0]);
%                 title('Yac21','FontName','Times New Roman','FontSize',11);
%                 ylabel('Magnitude(dB)','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'xticklabel',[]);
%                 set(gca,'Position',[0.11 0.31 0.41 0.17]);%14
%                 subplot 427
%                 h1=semilogx(w1,phase(Yvsc(3,:))*180/pi,'-');
%                 axis([f0 f1 -1080 0]);
%                 xticks([1 10 100 1000]);
%                 yticks([-1080 -720  -360  0 360]);
%                 xlabel('Frequency(Hz)','FontName','Times New Roman','FontSize',11);
%                 ylabel('Phase(deg)','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);%14,13,11
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'Position',[0.11 0.11 0.41 0.17]);%14
%
%                 %Yac22
%                 subplot 426
%                 h1=semilogx(w1,20*log10(abs(Yvsc(4,:))),'-');
%                 axis([f0 f1 -80 -20]);
%                 xticks([1 10 100 1000]);
%                 yticks([-80 -60 -40 -20 0]);
%                 title('Yac22','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'xticklabel',[]);
%                 set(gca,'yticklabel',[]);
%                 set(gca,'Position',[0.56 0.31 0.41 0.17]);%14
%                 subplot 428
%                 h1=semilogx(w1,phase(Yvsc(4,:))*180/pi,'-');
%                 axis([f0 f1 -1080 0]);
%                 xticks([1 10 100 1000]);
%                 yticks([-1080 -720  -360  0 360]);
%                 xlabel('Frequency(Hz)','FontName','Times New Roman','FontSize',11);
%                 grid on;
%                 set(gca,'FontName','Times New Roman','FontSize',11,'LineWidth',1);
%                 set(h1,'LineWidth',1.5);
%                 set(gca,'yticklabel',[]);
%                 set(gca,'Position',[0.56 0.11 0.41 0.17]);%14
%
%                 % legend({'GFL Y'},'FontSize',12,'Location',[0.1 0.95 0.8 0.05],'Orientation','horizon')
%                 % set(legend,'Box','off')
%
%
%             end
%         end
%     end
% end

%% data visualization