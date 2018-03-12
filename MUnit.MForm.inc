procedure InitializeComponent;
    begin
        self.name1 := new System.Windows.Forms.TextBox();
        self.value1 := new System.Windows.Forms.TextBox();
        self.delta1 := new System.Windows.Forms.TextBox();
        self.delta2 := new System.Windows.Forms.TextBox();
        self.value2 := new System.Windows.Forms.TextBox();
        self.name2 := new System.Windows.Forms.TextBox();
        self.label1 := new System.Windows.Forms.Label();
        self.label2 := new System.Windows.Forms.Label();
        self.label3 := new System.Windows.Forms.Label();
        self.delta4 := new System.Windows.Forms.TextBox();
        self.value4 := new System.Windows.Forms.TextBox();
        self.name4 := new System.Windows.Forms.TextBox();
        self.delta3 := new System.Windows.Forms.TextBox();
        self.value3 := new System.Windows.Forms.TextBox();
        self.name3 := new System.Windows.Forms.TextBox();
        self.delta8 := new System.Windows.Forms.TextBox();
        self.value8 := new System.Windows.Forms.TextBox();
        self.name8 := new System.Windows.Forms.TextBox();
        self.delta7 := new System.Windows.Forms.TextBox();
        self.value7 := new System.Windows.Forms.TextBox();
        self.name7 := new System.Windows.Forms.TextBox();
        self.delta6 := new System.Windows.Forms.TextBox();
        self.value6 := new System.Windows.Forms.TextBox();
        self.name6 := new System.Windows.Forms.TextBox();
        self.delta5 := new System.Windows.Forms.TextBox();
        self.value5 := new System.Windows.Forms.TextBox();
        self.name5 := new System.Windows.Forms.TextBox();
        self.label4 := new System.Windows.Forms.Label();
        self.formula := new System.Windows.Forms.TextBox();
        self.label5 := new System.Windows.Forms.Label();
        self.label6 := new System.Windows.Forms.Label();
        self.calcBtn := new System.Windows.Forms.Button();
        self.cleanBtn := new System.Windows.Forms.Button();
        self.result := new System.Windows.Forms.RichTextBox();
        self.SuspendLayout();
        // 
        // name1
        // 
        self.name1.Location := new System.Drawing.Point(35, 61);
        self.name1.Name := 'name1';
        self.name1.Size := new System.Drawing.Size(79, 20);
        self.name1.TabIndex := 0;
        // 
        // value1
        // 
        self.value1.Location := new System.Drawing.Point(120, 61);
        self.value1.Name := 'value1';
        self.value1.Size := new System.Drawing.Size(276, 20);
        self.value1.TabIndex := 1;
        self.value1.TextChanged += textBox1_TextChanged;
        // 
        // delta1
        // 
        self.delta1.Location := new System.Drawing.Point(402, 61);
        self.delta1.Name := 'delta1';
        self.delta1.Size := new System.Drawing.Size(100, 20);
        self.delta1.TabIndex := 2;
        // 
        // delta2
        // 
        self.delta2.Location := new System.Drawing.Point(402, 87);
        self.delta2.Name := 'delta2';
        self.delta2.Size := new System.Drawing.Size(100, 20);
        self.delta2.TabIndex := 5;
        // 
        // value2
        // 
        self.value2.Location := new System.Drawing.Point(120, 87);
        self.value2.Name := 'value2';
        self.value2.Size := new System.Drawing.Size(276, 20);
        self.value2.TabIndex := 4;
        // 
        // name2
        // 
        self.name2.Location := new System.Drawing.Point(35, 87);
        self.name2.Name := 'name2';
        self.name2.Size := new System.Drawing.Size(79, 20);
        self.name2.TabIndex := 3;
        // 
        // label1
        // 
        self.label1.Location := new System.Drawing.Point(35, 29);
        self.label1.Name := 'label1';
        self.label1.Size := new System.Drawing.Size(79, 23);
        self.label1.TabIndex := 6;
        self.label1.Text := 'Имя';
        self.label1.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.label1.Click += label1_Click;
        // 
        // label2
        // 
        self.label2.Location := new System.Drawing.Point(120, 29);
        self.label2.Name := 'label2';
        self.label2.Size := new System.Drawing.Size(276, 23);
        self.label2.TabIndex := 7;
        self.label2.Text := 'Значения (через ";")';
        self.label2.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.label2.Click += label2_Click;
        // 
        // label3
        // 
        self.label3.Location := new System.Drawing.Point(402, 29);
        self.label3.Name := 'label3';
        self.label3.Size := new System.Drawing.Size(100, 23);
        self.label3.TabIndex := 9;
        self.label3.Text := 'Погрешность';
        self.label3.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.label3.Click += label3_Click;
        // 
        // delta4
        // 
        self.delta4.Location := new System.Drawing.Point(402, 139);
        self.delta4.Name := 'delta4';
        self.delta4.Size := new System.Drawing.Size(100, 20);
        self.delta4.TabIndex := 15;
        // 
        // value4
        // 
        self.value4.Location := new System.Drawing.Point(120, 139);
        self.value4.Name := 'value4';
        self.value4.Size := new System.Drawing.Size(276, 20);
        self.value4.TabIndex := 14;
        // 
        // name4
        // 
        self.name4.Location := new System.Drawing.Point(35, 139);
        self.name4.Name := 'name4';
        self.name4.Size := new System.Drawing.Size(79, 20);
        self.name4.TabIndex := 13;
        // 
        // delta3
        // 
        self.delta3.Location := new System.Drawing.Point(402, 113);
        self.delta3.Name := 'delta3';
        self.delta3.Size := new System.Drawing.Size(100, 20);
        self.delta3.TabIndex := 12;
        // 
        // value3
        // 
        self.value3.Location := new System.Drawing.Point(120, 113);
        self.value3.Name := 'value3';
        self.value3.Size := new System.Drawing.Size(276, 20);
        self.value3.TabIndex := 11;
        // 
        // name3
        // 
        self.name3.Location := new System.Drawing.Point(35, 113);
        self.name3.Name := 'name3';
        self.name3.Size := new System.Drawing.Size(79, 20);
        self.name3.TabIndex := 10;
        // 
        // delta8
        // 
        self.delta8.Location := new System.Drawing.Point(402, 241);
        self.delta8.Name := 'delta8';
        self.delta8.Size := new System.Drawing.Size(100, 20);
        self.delta8.TabIndex := 27;
        self.delta8.TextChanged += textBox1_TextChanged;
        // 
        // value8
        // 
        self.value8.Location := new System.Drawing.Point(120, 241);
        self.value8.Name := 'value8';
        self.value8.Size := new System.Drawing.Size(276, 20);
        self.value8.TabIndex := 26;
        self.value8.TextChanged += textBox2_TextChanged;
        // 
        // name8
        // 
        self.name8.Location := new System.Drawing.Point(35, 241);
        self.name8.Name := 'name8';
        self.name8.Size := new System.Drawing.Size(79, 20);
        self.name8.TabIndex := 25;
        // 
        // delta7
        // 
        self.delta7.Location := new System.Drawing.Point(402, 215);
        self.delta7.Name := 'delta7';
        self.delta7.Size := new System.Drawing.Size(100, 20);
        self.delta7.TabIndex := 24;
        // 
        // value7
        // 
        self.value7.Location := new System.Drawing.Point(120, 215);
        self.value7.Name := 'value7';
        self.value7.Size := new System.Drawing.Size(276, 20);
        self.value7.TabIndex := 23;
        // 
        // name7
        // 
        self.name7.Location := new System.Drawing.Point(35, 215);
        self.name7.Name := 'name7';
        self.name7.Size := new System.Drawing.Size(79, 20);
        self.name7.TabIndex := 22;
        // 
        // delta6
        // 
        self.delta6.Location := new System.Drawing.Point(402, 189);
        self.delta6.Name := 'delta6';
        self.delta6.Size := new System.Drawing.Size(100, 20);
        self.delta6.TabIndex := 21;
        // 
        // value6
        // 
        self.value6.Location := new System.Drawing.Point(120, 189);
        self.value6.Name := 'value6';
        self.value6.Size := new System.Drawing.Size(276, 20);
        self.value6.TabIndex := 20;
        // 
        // name6
        // 
        self.name6.Location := new System.Drawing.Point(35, 189);
        self.name6.Name := 'name6';
        self.name6.Size := new System.Drawing.Size(79, 20);
        self.name6.TabIndex := 19;
        // 
        // delta5
        // 
        self.delta5.Location := new System.Drawing.Point(402, 163);
        self.delta5.Name := 'delta5';
        self.delta5.Size := new System.Drawing.Size(100, 20);
        self.delta5.TabIndex := 18;
        // 
        // value5
        // 
        self.value5.Location := new System.Drawing.Point(120, 163);
        self.value5.Name := 'value5';
        self.value5.Size := new System.Drawing.Size(276, 20);
        self.value5.TabIndex := 17;
        // 
        // name5
        // 
        self.name5.Location := new System.Drawing.Point(35, 163);
        self.name5.Name := 'name5';
        self.name5.Size := new System.Drawing.Size(79, 20);
        self.name5.TabIndex := 16;
        // 
        // label4
        // 
        self.label4.Location := new System.Drawing.Point(35, 276);
        self.label4.Name := 'label4';
        self.label4.Size := new System.Drawing.Size(79, 23);
        self.label4.TabIndex := 28;
        self.label4.Text := 'Формула';
        self.label4.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
        self.label4.Click += label4_Click;
        // 
        // formula
        // 
        self.formula.Location := new System.Drawing.Point(120, 278);
        self.formula.Name := 'formula';
        self.formula.Size := new System.Drawing.Size(276, 20);
        self.formula.TabIndex := 29;
        // 
        // label5
        // 
        self.label5.Location := new System.Drawing.Point(35, 312);
        self.label5.Name := 'label5';
        self.label5.Size := new System.Drawing.Size(79, 23);
        self.label5.TabIndex := 30;
        self.label5.Text := 'Результат:';
        self.label5.Click += label5_Click;
        // 
        // label6
        // 
        self.label6.Location := new System.Drawing.Point(35, 9);
        self.label6.Name := 'label6';
        self.label6.Size := new System.Drawing.Size(141, 20);
        self.label6.TabIndex := 32;
        self.label6.Text := 'Данные:';
        self.label6.Click += label6_Click;
        // 
        // calcBtn
        // 
        self.calcBtn.Location := new System.Drawing.Point(402, 278);
        self.calcBtn.Name := 'calcBtn';
        self.calcBtn.Size := new System.Drawing.Size(100, 26);
        self.calcBtn.TabIndex := 33;
        self.calcBtn.Text := 'Вычислить';
        self.calcBtn.UseVisualStyleBackColor := true;
        // 
        // cleanBtn
        // 
        self.cleanBtn.Location := new System.Drawing.Point(402, 310);
        self.cleanBtn.Name := 'cleanBtn';
        self.cleanBtn.Size := new System.Drawing.Size(100, 25);
        self.cleanBtn.TabIndex := 34;
        self.cleanBtn.Text := 'Очистить';
        self.cleanBtn.UseVisualStyleBackColor := true;
        // 
        // result
        // 
        self.result.Location := new System.Drawing.Point(120, 312);
        self.result.Name := 'result';
        self.result.Size := new System.Drawing.Size(276, 123);
        self.result.TabIndex := 35;
        self.result.Text := '';
        // 
        // MForm
        // 
        self.ClientSize := new System.Drawing.Size(541, 467);
        self.Controls.Add(self.result);
        self.Controls.Add(self.cleanBtn);
        self.Controls.Add(self.calcBtn);
        self.Controls.Add(self.label6);
        self.Controls.Add(self.label5);
        self.Controls.Add(self.formula);
        self.Controls.Add(self.label4);
        self.Controls.Add(self.delta8);
        self.Controls.Add(self.value8);
        self.Controls.Add(self.name8);
        self.Controls.Add(self.delta7);
        self.Controls.Add(self.value7);
        self.Controls.Add(self.name7);
        self.Controls.Add(self.delta6);
        self.Controls.Add(self.value6);
        self.Controls.Add(self.name6);
        self.Controls.Add(self.delta5);
        self.Controls.Add(self.value5);
        self.Controls.Add(self.name5);
        self.Controls.Add(self.delta4);
        self.Controls.Add(self.value4);
        self.Controls.Add(self.name4);
        self.Controls.Add(self.delta3);
        self.Controls.Add(self.value3);
        self.Controls.Add(self.name3);
        self.Controls.Add(self.label3);
        self.Controls.Add(self.label2);
        self.Controls.Add(self.label1);
        self.Controls.Add(self.delta2);
        self.Controls.Add(self.value2);
        self.Controls.Add(self.name2);
        self.Controls.Add(self.delta1);
        self.Controls.Add(self.value1);
        self.Controls.Add(self.name1);
        self.Name := 'MForm';
        self.Text := 'fizdelta';
        self.Load += MForm_Load;
        self.ResumeLayout(false);
        self.PerformLayout();
    end;
