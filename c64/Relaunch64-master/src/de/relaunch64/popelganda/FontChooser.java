/*
 * Relaunch64 - A Java cross-development IDE for C64 machine language coding.
 * Copyright (C) 2001-2015 by Daniel Lüdecke (http://www.danielluedecke.de)
 * 
 * Homepage: http://www.popelganda.de
 * 
 * 
 * This program is free software; you can redistribute it and/or modify it under the terms of the
 * GNU General Public License as published by the Free Software Foundation; either version 3 of 
 * the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program;
 * if not, see <http://www.gnu.org/licenses/>.
 * 
 * 
 * Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU
 * General Public License, wie von der Free Software Foundation veröffentlicht, weitergeben
 * und/oder modifizieren, entweder gemäß Version 3 der Lizenz oder (wenn Sie möchten)
 * jeder späteren Version.
 * 
 * Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein 
 * wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder 
 * der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details finden Sie in der 
 * GNU General Public License.
 * 
 * Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm 
 * erhalten haben. Falls nicht, siehe <http://www.gnu.org/licenses/>.
 */

package de.relaunch64.popelganda;

import de.relaunch64.popelganda.util.ConstantsR64;
import java.awt.Font;
import java.awt.GraphicsEnvironment;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import javax.swing.DefaultListModel;
import javax.swing.JComponent;
import javax.swing.KeyStroke;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import org.jdesktop.application.Action;

/**
 * This class is a simple font-chooser. The font passed as parameter is set as
 * default selections in the lists.
 * 
 * @author  danielludecke
 */
public class FontChooser extends javax.swing.JDialog {

    /**
     * This variable stores the font-selection of the user. we pass the current used
     * font as parameter, and store the changes in this variable.
     */
    private Font selectedFont;
    /**
     * DefaultListModel to get access to the lists' data
     */
    private DefaultListModel listmodelFont = new DefaultListModel();
    /**
     * DefaultListModel to get access to the lists' data
     */
    private final DefaultListModel listmodelSize = new DefaultListModel();
    
    
    /**
     * 
     * @param parent
     * @param f 
     */
    public FontChooser(java.awt.Frame parent, Font f) {
        super(parent);
        initComponents();
        // set application icon
        setIconImage(ConstantsR64.r64icon.getImage());
        selectedFont=f;
        //
        // init font-list
        //
        // retrieve a list with all installed fonts
        String[] fonts = GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
        // and set them to the list view
        for (String fts : fonts) listmodelFont.addElement(fts);
        //
        // init size-list
        //
        // build a list with size-values
        for (int i=8; i<=72; i++) listmodelSize.addElement(i);
        // make the default selection for the font family
        int index = listmodelFont.indexOf(selectedFont.getFamily());
        // if we found a valid font-name, select it
        if (index!=-1) jListFont.setSelectedIndex(index);
        // else select first font per default
        else jListFont.setSelectedIndex(0);
        // make sure, the selected item is visible
        jListFont.ensureIndexIsVisible(index);
        // these codelines add an escape-listener to the dialog. so, when the user
        // presses the escape-key, the same action is performed as if the user
        // presses the cancel button...
        KeyStroke stroke = KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0);
        /**
         * JDK 8 Lambda
         */
//        ActionListener cancelAction = (ActionEvent evt) -> {
//            cancelFont();
//        };
        ActionListener cancelAction = new java.awt.event.ActionListener() {
            @Override public void actionPerformed(ActionEvent evt) {
                cancelFont();
            }
        };
        getRootPane().registerKeyboardAction(cancelAction, stroke, JComponent.WHEN_IN_FOCUSED_WINDOW);

        // get font-size
        int size=selectedFont.getSize();
        // try to find the size number
        index = listmodelSize.indexOf(size);
        // and select the related value in the list
        if (index!=-1) jListSize.setSelectedIndex(index);
        else jListSize.setSelectedIndex(3);
        // make sure, the selected item is visible
        jListSize.ensureIndexIsVisible(index);
        // add listeners manually, so we don't fire any events when initiating the lists
        /**
         * JDK 8 Lambda
         */
//        jListFont.addListSelectionListener((javax.swing.event.ListSelectionEvent evt) -> {
//            fontChanged();
//        });
//        jListSize.addListSelectionListener((javax.swing.event.ListSelectionEvent evt) -> {
//            fontChanged();
//        });
        jListFont.addListSelectionListener(new javax.swing.event.ListSelectionListener() {
            @Override public void valueChanged(javax.swing.event.ListSelectionEvent evt) {
                fontChanged();
            }
        });
        jListSize.addListSelectionListener(new javax.swing.event.ListSelectionListener() {
            @Override public void valueChanged(javax.swing.event.ListSelectionEvent evt) {
                fontChanged();
            }
        });
        // add document listener, that instantly check for a correct filepath
        jTextFieldFilter.getDocument().addDocumentListener(new DocumentListener() {
            @Override public void changedUpdate(DocumentEvent e) { gotoFont(); }
            @Override public void insertUpdate(DocumentEvent e) { gotoFont(); }
            @Override public void removeUpdate(DocumentEvent e) { gotoFont(); }
        });
        
        updatePreview(selectedFont);
    }

    public Font getSelectedFont() {
        return selectedFont;
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jListFont = new javax.swing.JList();
        jTextFieldFilter = new javax.swing.JTextField();
        jPanel4 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jListSize = new javax.swing.JList();
        jPanel5 = new javax.swing.JPanel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jEditorPanePreview = new javax.swing.JEditorPane();
        jButtonApply = new javax.swing.JButton();
        jButtonCancel = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(de.relaunch64.popelganda.Relaunch64App.class).getContext().getResourceMap(FontChooser.class);
        setTitle(resourceMap.getString("FormFontChooser.title")); // NOI18N
        setModal(true);
        setName("FormFontChooser"); // NOI18N

        jPanel1.setName("jPanel1"); // NOI18N

        jPanel2.setName("jPanel2"); // NOI18N

        jLabel1.setText(resourceMap.getString("jLabel1.text")); // NOI18N
        jLabel1.setName("jLabel1"); // NOI18N

        jScrollPane1.setName("jScrollPane1"); // NOI18N

        jListFont.setModel(listmodelFont);
        jListFont.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jListFont.setName("jListFont"); // NOI18N
        jScrollPane1.setViewportView(jListFont);

        jTextFieldFilter.setText(resourceMap.getString("jTextFieldFilter.text")); // NOI18N
        jTextFieldFilter.setName("jTextFieldFilter"); // NOI18N

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 311, Short.MAX_VALUE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jTextFieldFilter)))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldFilter, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 215, Short.MAX_VALUE)
                .addContainerGap())
        );

        jPanel4.setName("jPanel4"); // NOI18N

        jLabel3.setText(resourceMap.getString("jLabel3.text")); // NOI18N
        jLabel3.setName("jLabel3"); // NOI18N

        jScrollPane3.setName("jScrollPane3"); // NOI18N

        jListSize.setModel(listmodelSize);
        jListSize.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jListSize.setName("jListSize"); // NOI18N
        jScrollPane3.setViewportView(jListSize);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 123, Short.MAX_VALUE)
                    .addComponent(jLabel3))
                .addContainerGap())
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane3)
                .addContainerGap())
        );

        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder(resourceMap.getString("jPanel5.border.title"))); // NOI18N
        jPanel5.setName("jPanel5"); // NOI18N

        jScrollPane4.setBorder(null);
        jScrollPane4.setName("jScrollPane4"); // NOI18N

        jEditorPanePreview.setEditable(false);
        jEditorPanePreview.setBorder(null);
        jEditorPanePreview.setContentType(resourceMap.getString("jEditorPanePreview.contentType")); // NOI18N
        jEditorPanePreview.setName("jEditorPanePreview"); // NOI18N
        jScrollPane4.setViewportView(jEditorPanePreview);

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane4)
                .addContainerGap())
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 135, Short.MAX_VALUE)
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                        .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );

        javax.swing.ActionMap actionMap = org.jdesktop.application.Application.getInstance(de.relaunch64.popelganda.Relaunch64App.class).getContext().getActionMap(FontChooser.class, this);
        jButtonApply.setAction(actionMap.get("applyFont")); // NOI18N
        jButtonApply.setName("jButtonApply"); // NOI18N

        jButtonCancel.setAction(actionMap.get("cancelFont")); // NOI18N
        jButtonCancel.setName("jButtonCancel"); // NOI18N

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jButtonCancel)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonApply)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonApply)
                    .addComponent(jButtonCancel))
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents


    /**
     * When the user cancels the dialog, we set the font-variable to null. since we
     * check "selectedFont" as return value, a "null" indicates the cancel-action
     */
    @Action
    public void cancelFont() {
        selectedFont = null;
        dispose();
        setVisible(false);
    }
    
    
    /**
     * When the user applies the changes, the selected font value contains the new font.
     */
    @Action
    public void applyFont() {
        dispose();
        setVisible(false);
    }
    
    
    /**
     * This method gets the input from the textfield jTextFieldFilter and searched the font-list
     * for fonts that begin with the entered text. If a matching font was found, it is selected.
     */
    private void gotoFont() {
        // get the entered text
        String f = jTextFieldFilter.getText().toLowerCase();
        // retrieve the list model
        listmodelFont = (DefaultListModel)jListFont.getModel();
        // go through all fonts in the list
        for (int cnt=0; cnt<listmodelFont.getSize(); cnt++) {
            // get current font
            String font = listmodelFont.get(cnt).toString().toLowerCase();
            // if the font starts with the entered text, select it
            if (font.startsWith(f)) {
                jListFont.setSelectedIndex(cnt);
                jListFont.ensureIndexIsVisible(cnt);
                return;
            }
        }
    }
    
    
    /**
     * This method is called each time the user chooses a selection from any list. The new
     * style, fontname or size are immediately applied to the variable "selectedFont" and
     * the preview-label is being updated.
     */
    private void fontChanged() { 
        int size = jListSize.getSelectedIndex()+8;
        String name = jListFont.getSelectedValue().toString();
        selectedFont = new Font(name, Font.PLAIN, size);
        updatePreview(selectedFont);
    } 
    
    
    /**
     * This method creates a html-page with css-style-definition from the font-properties.
     * The html-page is then set to the editorpane und used as preview panel...
     * @param f the font we want to preview
     */
    private void updatePreview(Font f) {
        StringBuilder css = new StringBuilder("");
        
        String style="normal";
        String weight="normal";
        
        if (Font.PLAIN==f.getStyle()) {
            style="normal";
            weight="normal";
        }
        else if (Font.BOLD==f.getStyle()) {
            style="normal";
            weight="bold";
        }
        else if (Font.ITALIC==f.getStyle()) {
            style="italic";
            weight="normal";
        }
        else if ((Font.BOLD+Font.ITALIC)==f.getStyle()) {
            style="italic";
            weight="bold";
        }
        
        // body-tag with main font settings
        css.append("<html>\n<head>\n<style>\nbody{font-family:");
        css.append(f.getFamily());
        css.append(";font-size:");
        css.append(String.valueOf(f.getSize()));
        css.append("pt;color:#000000");
        css.append(";font-style:");
        css.append(style);
        css.append(";font-weight:");
        css.append(weight);
        css.append(";}\n</style>\n</head>\n<body>\n");
        css.append("<p>abcdef ABCDEG<br>1234567890<br><br>LDA #$01<br>STA $D020<br><br>.text \"hello world...\"<br><br>Relaunch64 - Preview!</p></body>\n</html>");
        
        jEditorPanePreview.setText(css.toString());
    }
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonApply;
    private javax.swing.JButton jButtonCancel;
    private javax.swing.JEditorPane jEditorPanePreview;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JList jListFont;
    private javax.swing.JList jListSize;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JTextField jTextFieldFilter;
    // End of variables declaration//GEN-END:variables

}
