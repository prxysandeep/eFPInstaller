namespace eFPInstallerUI
{
    partial class InstallPage
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(InstallPage));
            this.btnInstall = new System.Windows.Forms.Button();
            this.picProgress = new System.Windows.Forms.PictureBox();
            this.ProcessingText = new System.Windows.Forms.Label();
            this.imgPictureBox = new System.Windows.Forms.PictureBox();
            this.StatusGrid = new System.Windows.Forms.DataGridView();
          this.Status = new System.Windows.Forms.DataGridViewImageColumn();
            this.Process = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.btnResume = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.picProgress)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imgPictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.StatusGrid)).BeginInit();
            this.SuspendLayout();
            // 
            // btnInstall
            // 
            this.btnInstall.Location = new System.Drawing.Point(115, 220);
            this.btnInstall.Name = "btnInstall";
            this.btnInstall.Size = new System.Drawing.Size(140, 33);
            this.btnInstall.TabIndex = 0;
            this.btnInstall.Text = "Install";
            this.btnInstall.UseVisualStyleBackColor = true;
            this.btnInstall.Click += new System.EventHandler(this.BtnInstall_Click);
            // 
            // picProgress
            // 
            this.picProgress.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.picProgress.BackColor = System.Drawing.Color.White;
            this.picProgress.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.picProgress.Location = new System.Drawing.Point(115, 145);
            this.picProgress.Name = "picProgress";
            this.picProgress.Size = new System.Drawing.Size(651, 50);
            this.picProgress.TabIndex = 4;
            this.picProgress.TabStop = false;
            this.picProgress.Visible = false;
            this.picProgress.Paint += new System.Windows.Forms.PaintEventHandler(this.picProgress_Paint);
            // 
            // ProcessingText
            // 
            this.ProcessingText.AutoSize = true;
            this.ProcessingText.Location = new System.Drawing.Point(122, 206);
            this.ProcessingText.Name = "ProcessingText";
            this.ProcessingText.Size = new System.Drawing.Size(0, 17);
            this.ProcessingText.TabIndex = 3;
            // 
            // imgPictureBox
            // 
            this.imgPictureBox.Image = ((System.Drawing.Image)(resources.GetObject("imgPictureBox.Image")));
            this.imgPictureBox.Location = new System.Drawing.Point(225, 23);
            this.imgPictureBox.Name = "imgPictureBox";
            this.imgPictureBox.Size = new System.Drawing.Size(362, 72);
            this.imgPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imgPictureBox.TabIndex = 6;
            this.imgPictureBox.TabStop = false;
            // 
            // StatusGrid
            // 
            this.StatusGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
 this.StatusGrid.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Status,
            this.Process});
            this.StatusGrid.Location = new System.Drawing.Point(115, 301);
            this.StatusGrid.Name = "StatusGrid";
            this.StatusGrid.RowHeadersWidth = 51;
            this.StatusGrid.RowTemplate.Height = 24;
            this.StatusGrid.Size = new System.Drawing.Size(651, 234);
            this.StatusGrid.TabIndex = 7;
this.StatusGrid.Visible = false;
            // 
  // Status
            // 
            this.Status.HeaderText = "";
            this.Status.Name = "Status";
            this.Status.ReadOnly = true;
            this.Status.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Status.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Status.Width = 60;
            // 
            // Process
            // 
            this.Process.HeaderText = "Process";
            this.Process.Name = "Process";
            this.Process.ReadOnly = true;
            this.Process.Width = 250;
            // 
            // btnResume
            // 
            this.btnResume.Location = new System.Drawing.Point(357, 220);
            this.btnResume.Name = "btnResume";
            this.btnResume.Size = new System.Drawing.Size(140, 33);
            this.btnResume.TabIndex = 8;
            this.btnResume.Text = "Resume Installation";
            this.btnResume.UseVisualStyleBackColor = true;
            this.btnResume.Click += new System.EventHandler(this.btnResume_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(626, 220);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(140, 33);
            this.btnCancel.TabIndex = 9;
            this.btnCancel.Text = "Cancel Installation";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // InstallPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(887, 566);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnResume);
            this.Controls.Add(this.StatusGrid);
            this.Controls.Add(this.imgPictureBox);
            this.Controls.Add(this.ProcessingText);
            this.Controls.Add(this.picProgress);
            this.Controls.Add(this.btnInstall);
            this.Name = "InstallPage";
            this.Text = "eFinancePlus Installer";
            ((System.ComponentModel.ISupportInitialize)(this.picProgress)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imgPictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.StatusGrid)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnInstall;
        private System.Windows.Forms.PictureBox picProgress;
        private System.Windows.Forms.Label ProcessingText;
        private System.Windows.Forms.PictureBox imgPictureBox;
        private System.Windows.Forms.DataGridView StatusGrid;
  private System.Windows.Forms.DataGridViewImageColumn Status;
        private System.Windows.Forms.DataGridViewTextBoxColumn Process;
        private System.Windows.Forms.Button btnResume;
        private System.Windows.Forms.Button btnCancel;
    }
}

