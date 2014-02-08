;   ���⮩ �ਬ�� �ணࠬ�� ��� KolibriOS
;   ����稢��� ��� ����⮩ ������
;
;   �������஢��� FASM'��
;        ����� ������ example.asm �१ �ணࠬ�� FASM (�� ��� ����
;        �� ࠡ�祬 �⮫�)
;        � ����� ���� ������ F9 � Tinypad'�. ��� �������樨 
;        �⮡ࠦ����� �� ��᪥ �⫠��� (�ணࠬ�� BOARD)
;
;   �� ����� ����� �� �ணࠬ��஢���� ��� ������:
;        ����� �㭪樨 ����頥��� � ॣ���� eax.
;        �맮� ��⥬��� �㭪樨 �����⢫���� �������� "int 0x40".
;        �� ॣ�����, �஬� � 㪠������ � �����頥��� ���祭��,
;        ������ ॣ���� 䫠��� eflags, ��࠭�����.
;
;    �ਬ��:
;        mov eax, 1    ;�㭪�� 1 - ���⠢��� ��� � ����
;                      ;ᯨ᮪ ���㭪権 �. � DOCPACK - sysfuncr.txt
;        mov ebx, 10   ; ���न��� x=10
;        mov ecx, 20   ; ���न��� y=10
;        mov edx, 0xFFFfff ;梥� �窨
;        int 0x40      ;�맢��� �㭪��
;
;    ���� ᠬ�� � �ᯮ�짮������ �����:
;        mcall 1, 10, 20, 0xFFFfff
;---------------------------------------------------------------------

  use32              ; ������� 32-���� ०�� ��ᥬ����
  org    0x0         ; ������ � ���

  db     'MENUET01'  ; 8-����� �����䨪��� MenuetOS
  dd     0x01        ; ����� ��������� (�ᥣ�� 1)
  dd     START       ; ���� ��ࢮ� �������
  dd     I_END       ; ࠧ��� �ணࠬ��
  dd     0x1000      ; ������⢮ �����
  dd     0x1000      ; ���� ���設� �����
  dd     0x0         ; ���� ���� ��� ��ࠬ��஢
  dd     0x0         ; ��१�ࢨ஢���

include 'lang.inc'
include 'macros.inc' ; ������ �������� ����� ��ᥬ����騪��!

;---------------------------------------------------------------------
;---  ������ ���������  ----------------------------------------------
;---------------------------------------------------------------------

START:

red:                    ; ����ᮢ��� ����

    call draw_window    ; ��뢠�� ��楤��� ���ᮢ�� ����

;---------------------------------------------------------------------
;---  ���� ��������� �������  ----------------------------------------
;---------------------------------------------------------------------

still:
    mcall 10            ; �㭪�� 10 - ����� ᮡ���

    cmp  eax,1          ; ����ᮢ��� ���� ?
    je   red            ; �᫨ �� - �� ���� red
    cmp  eax,2          ; ����� ������ ?
    je   key            ; �᫨ �� - �� key
    cmp  eax,3          ; ����� ������ ?
    je   button         ; �᫨ �� - �� button

    jmp  still          ; �᫨ ��㣮� ᮡ�⨥ - � ��砫� 横��


;---------------------------------------------------------------------


  key:                  ; ����� ������ �� ���������
    mcall 2             ; �㭪�� 2 - ����� ��� ᨬ���� (� ah)

    mov  [Music+1], ah  ; ������� ��� ᨬ���� ��� ��� ����

    ; �㭪�� 55-55: ��⥬�� ������� ("PlayNote")
    ;   esi - ���� �������

    ;   mov  eax,55
    ;   mov  ebx,eax
    ;   mov  esi,Music
    ;   int  0x40

    ; ��� ���⪮:
    mcall 55, eax, , , Music

    jmp  still          ; �������� � ��砫� 横��

;---------------------------------------------------------------------

  button:
    mcall 17            ; 17 - ������� �����䨪��� ����⮩ ������

    cmp   ah, 1         ; �᫨ �� ����� ������ � ����஬ 1,
    jne   still         ;  ��������

  .exit:
    mcall -1            ; ���� ����� �ணࠬ��



;---------------------------------------------------------------------
;---  ����������� � ��������� ����  ----------------------------------
;---------------------------------------------------------------------

draw_window:

    mcall 12, 1                    ; �㭪�� 12: ᮮ���� �� �� ���ᮢ�� ����
                                   ; 1 - ��稭��� �ᮢ���

    ; �����: ᭠砫� ������ ��ਠ�� (���������஢����)
    ;        ��⥬ ���⪨� ������ � �ᯮ�짮������ ����ᮢ


                                   ; ������� ����
;   mov  eax,0                     ; �㭪�� 0 : ��।����� � ���ᮢ��� ����
;   mov  ebx,200*65536+200         ; [x ����] *65536 + [x ࠧ���]
;   mov  ecx,200*65536+50          ; [y ����] *65536 + [y ࠧ���]
;   mov  edx,0x33aabbcc            ; 梥� ࠡ�祩 ������  RRGGBB,8->color gl
;   mov  edi,header                ; ��������� ����
;   int  0x40

    mcall 0, <200,200>, <200,50>, 0x33AABBCC,,title

                                   

;   mov  eax,4
;   mov  ebx,3 shl 16 + 8
;   mov  ecx,0
;   mov  edx,message
;   mov  esi,message.size
;   int  0x40

    mcall 4, <3, 8>, 0, message, message.size

    mcall 12, 2                    ; �㭪�� 12: ᮮ���� �� �� ���ᮢ�� ����
                                   ; 2, �����稫� �ᮢ���

    ret                            ; ��室�� �� ��楤���


;---------------------------------------------------------------------
;---  ������ ���������  ----------------------------------------------
;---------------------------------------------------------------------

; ��� ⠪�� ��� ���⪠� "�������".
; ��ன ���� ��������� ����⨥� �������

Music:
  db  0x90, 0x30, 0


;---------------------------------------------------------------------

; ����䥩� �ணࠬ�� ���������
;  �� ����� ������ �� � MACROS.INC (lang fix ��)

lsz message,\
  ru,'������ ���� �������...',\
  en,'Press any key...',\
  fr,'Pressez une touche...'

lsz title,\
  ru,'������ ���������',\
  en,'EXAMPLE APPLICATION',\
  fr,"L'exemplaire programme"

;---------------------------------------------------------------------

I_END:                             ; ��⪠ ���� �ணࠬ��