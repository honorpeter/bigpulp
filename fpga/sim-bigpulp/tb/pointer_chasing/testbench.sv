time clk_period = 10ns;    // clock generated by ARM

task tb_wait(input int cycles);
   #(clk_period*cycles);
endtask

module testbench;

  timeunit      1ps;
  timeprecision 1ps;

  logic   ACLK;    // input
  logic   ARESETn; // input

  logic [31:0] m_axi_sim_araddr  ;
  logic  [1:0] m_axi_sim_arburst ;
  logic  [3:0] m_axi_sim_arcache ;
  logic [13:0] m_axi_sim_arid    ;
  logic  [7:0] m_axi_sim_arlen   ;
  logic        m_axi_sim_arlock  ;
  logic  [2:0] m_axi_sim_arprot  ;
  logic  [3:0] m_axi_sim_arqos   ;
  logic        m_axi_sim_arready ;
  logic  [3:0] m_axi_sim_arregion;
  logic  [2:0] m_axi_sim_arsize  ;
  logic        m_axi_sim_arvalid ;
  logic [31:0] m_axi_sim_awaddr  ;
  logic  [1:0] m_axi_sim_awburst ;
  logic  [3:0] m_axi_sim_awcache ;
  logic [13:0] m_axi_sim_awid    ;
  logic  [7:0] m_axi_sim_awlen   ;
  logic        m_axi_sim_awlock  ;
  logic  [2:0] m_axi_sim_awprot  ;
  logic  [3:0] m_axi_sim_awqos   ;
  logic        m_axi_sim_awready ;
  logic  [3:0] m_axi_sim_awregion;
  logic  [2:0] m_axi_sim_awsize  ;
  logic        m_axi_sim_awvalid ;
  logic [13:0] m_axi_sim_bid     ;
  logic        m_axi_sim_bready  ;
  logic  [1:0] m_axi_sim_bresp   ;
  logic        m_axi_sim_bvalid  ;
  logic [63:0] m_axi_sim_rdata   ;
  logic [13:0] m_axi_sim_rid     ;
  logic        m_axi_sim_rlast   ;
  logic        m_axi_sim_rready  ;
  logic  [1:0] m_axi_sim_rresp   ;
  logic        m_axi_sim_rvalid  ;
  logic [63:0] m_axi_sim_wdata   ;
  logic        m_axi_sim_wlast   ;
  logic        m_axi_sim_wready  ;
  logic  [7:0] m_axi_sim_wstrb   ;
  logic        m_axi_sim_wvalid  ;

  logic        pulp2host_intr    ;

  // bigPULP SoC
  bigpulp_top DUT (
    .ACLK               ( ACLK               ),
    .ARESETn            ( ARESETn            ),

    .tmif_clkl_x1       ( ACLK               ),
    .tmif_resetn        ( ARESETn            ),

    .m_axi_sim_araddr   ( m_axi_sim_araddr   ),
    .m_axi_sim_arburst  ( m_axi_sim_arburst  ),
    .m_axi_sim_arcache  ( m_axi_sim_arcache  ),
    .m_axi_sim_arid     ( m_axi_sim_arid     ),
    .m_axi_sim_arlen    ( m_axi_sim_arlen    ),
    .m_axi_sim_arlock   ( m_axi_sim_arlock   ),
    .m_axi_sim_arprot   ( m_axi_sim_arprot   ),
    .m_axi_sim_arqos    ( m_axi_sim_arqos    ),
    .m_axi_sim_arready  ( m_axi_sim_arready  ),
    .m_axi_sim_arregion ( m_axi_sim_arregion ),
    .m_axi_sim_arsize   ( m_axi_sim_arsize   ),
    .m_axi_sim_arvalid  ( m_axi_sim_arvalid  ),
    .m_axi_sim_awaddr   ( m_axi_sim_awaddr   ),
    .m_axi_sim_awburst  ( m_axi_sim_awburst  ),
    .m_axi_sim_awcache  ( m_axi_sim_awcache  ),
    .m_axi_sim_awid     ( m_axi_sim_awid     ),
    .m_axi_sim_awlen    ( m_axi_sim_awlen    ),
    .m_axi_sim_awlock   ( m_axi_sim_awlock   ),
    .m_axi_sim_awprot   ( m_axi_sim_awprot   ),
    .m_axi_sim_awqos    ( m_axi_sim_awqos    ),
    .m_axi_sim_awready  ( m_axi_sim_awready  ),
    .m_axi_sim_awregion ( m_axi_sim_awregion ),
    .m_axi_sim_awsize   ( m_axi_sim_awsize   ),
    .m_axi_sim_awvalid  ( m_axi_sim_awvalid  ),
    .m_axi_sim_bid      ( m_axi_sim_bid      ),
    .m_axi_sim_bready   ( m_axi_sim_bready   ),
    .m_axi_sim_bresp    ( m_axi_sim_bresp    ),
    .m_axi_sim_bvalid   ( m_axi_sim_bvalid   ),
    .m_axi_sim_rdata    ( m_axi_sim_rdata    ),
    .m_axi_sim_rid      ( m_axi_sim_rid      ),
    .m_axi_sim_rlast    ( m_axi_sim_rlast    ),
    .m_axi_sim_rready   ( m_axi_sim_rready   ),
    .m_axi_sim_rresp    ( m_axi_sim_rresp    ),
    .m_axi_sim_rvalid   ( m_axi_sim_rvalid   ),
    .m_axi_sim_wdata    ( m_axi_sim_wdata    ),
    .m_axi_sim_wlast    ( m_axi_sim_wlast    ),
    .m_axi_sim_wready   ( m_axi_sim_wready   ),
    .m_axi_sim_wstrb    ( m_axi_sim_wstrb    ),
    .m_axi_sim_wvalid   ( m_axi_sim_wvalid   ),

    .pulp2host_intr_o   ( pulp2host_intr     )
  );

  ///////////////////////////
  //
  // axi4lite verification ip
  //
  ///////////////////////////
  axi4lite_m_if axi_m_if_0(ACLK);

  // Master write address channel
  assign m_axi_sim_awaddr   = axi_m_if_0.awaddr ;
  assign m_axi_sim_awvalid  = axi_m_if_0.awvalid;
  assign axi_m_if_0.awready = m_axi_sim_awready ;
  // Master write data channel
  assign m_axi_sim_wdata    = axi_m_if_0.wdata  ;
  assign m_axi_sim_wstrb    = axi_m_if_0.wstrb  ;
  assign m_axi_sim_wvalid   = axi_m_if_0.wvalid ;
  assign axi_m_if_0.wready  = m_axi_sim_wready  ;
  // Master write response channel
  assign axi_m_if_0.bresp   = m_axi_sim_bresp   ;
  assign axi_m_if_0.bvalid  = m_axi_sim_bvalid  ;
  assign m_axi_sim_bready   = axi_m_if_0.bready ;
  // Master read address channel
  assign m_axi_sim_araddr   = axi_m_if_0.araddr ;
  assign m_axi_sim_arvalid  = axi_m_if_0.arvalid;
  assign axi_m_if_0.arready = m_axi_sim_arready ;
  // Master read data channel
  assign axi_m_if_0.rdata   = m_axi_sim_rdata  ;
  assign axi_m_if_0.rresp   = m_axi_sim_rresp   ;
  assign axi_m_if_0.rvalid  = m_axi_sim_rvalid  ;
  assign m_axi_sim_rready   = axi_m_if_0.rready ;

  // Master write address channel
  assign m_axi_sim_awid     = '0;
  assign m_axi_sim_awlen    = 8'h00;   // 1 beat
  assign m_axi_sim_awsize   = 3'b010;  // 4 bytes
  assign m_axi_sim_awburst  = 2'b00;   // fixed
  assign m_axi_sim_awlock   = 1'b0;    // normal
  assign m_axi_sim_awcache  = 4'b0010; // normal non-cacheable non-bufferable
  assign m_axi_sim_awprot   = 3'b010;  // unpriviledged, non-secure, data
  assign m_axi_sim_awqos    = 4'h0;    // no QoS scheme
  assign m_axi_sim_awregion = '0;
  // Master write data channel
  assign m_axi_sim_wlast   = 1'b1;
  // Master write response channel
  //m_axi_sim_bid
  // Master read address channel
  assign m_axi_sim_arid     = '0;
  assign m_axi_sim_arlen    = 8'h00;   // 1 beat
  assign m_axi_sim_arsize   = 3'b010;  // 4 bytes
  assign m_axi_sim_arburst  = 2'b00;   // fixed
  assign m_axi_sim_arlock   = 1'b0;    // normal
  assign m_axi_sim_arcache  = 4'b0010; // normal non-cacheable non-bufferable
  assign m_axi_sim_arprot   = 3'b010;  // unpriviledged, non-secure, data
  assign m_axi_sim_arqos    = 4'h0;    // no QoS scheme
  assign m_axi_sim_arregion = '0;
  // Master read data channel
  //m_axi_sim_rid
  //m_axi_sim_rlast

  import AXI4LITE_M::*;
  typedef bit [7:0] bit8;

  task DataPack64(input longint data, output bit8 pkt[]);
    pkt = new[8];
    pkt[0] = data[7:0];
    pkt[1] = data[15:8];
    pkt[2] = data[23:16];
    pkt[3] = data[31:24];
    pkt[4] = data[39:32];
    pkt[5] = data[47:40];
    pkt[6] = data[55:48];
    pkt[7] = data[63:56];
  endtask // DataPack

  task DataPack32(input int data, output bit8 pkt[]);
    pkt = new[4];
    pkt[0] = data[7:0];
    pkt[1] = data[15:8];
    pkt[2] = data[23:16];
    pkt[3] = data[31:24];
  endtask // DataPack

  task DataUnpack64(output longint data, input bit8 pkt[]);
    data[7:0]   = pkt[0];
    data[15:8]  = pkt[1];
    data[23:16] = pkt[2];
    data[31:24] = pkt[3];
    data[39:32] = pkt[4];
    data[47:40] = pkt[5];
    data[55:48] = pkt[6];
    data[63:56] = pkt[7];
  endtask // DataUnpack

  task DataUnpack32(output longint data, input bit8 pkt[]);
    data[7:0]   = pkt[0];
    data[15:8]  = pkt[1];
    data[23:16] = pkt[2];
    data[31:24] = pkt[3];
  endtask // DataUnpack

  task pulp_write64(AXI4Lite_m_env axi_m, input int address, input longint data);
    bit8 dataIn[], wrRespOut[];
    int unsigned wrRespPtr;

    DataPack64(data,dataIn);
    axi_m.writeData(wrRespPtr, address, dataIn);
    axi_m.getWrResp(wrRespPtr, wrRespOut);
  endtask // pulp_write64

  task pulp_write32(AXI4Lite_m_env axi_m, input int address, input int data);
    bit8 dataIn[], wrRespOut[];
    int unsigned wrRespPtr;

    DataPack32(data,dataIn);
    axi_m.writeData(wrRespPtr, address, dataIn);
    axi_m.getWrResp(wrRespPtr, wrRespOut);
  endtask // pulp_write64

  task pulp_read64(AXI4Lite_m_env axi_m, input int address, output longint data);
    bit8 dataOut[], rdRespOut[];
    int unsigned rdPtr;

    axi_m.readData(address,8,rdPtr);
    axi_m.getData(rdPtr, dataOut, rdRespOut);
    DataUnpack64(data,dataOut);
  endtask // pulp_read64

  task pulp_read32(AXI4Lite_m_env axi_m, input int address, output int data);
    bit8 dataOut[], rdRespOut[];
    int unsigned rdPtr;

    axi_m.readData(address,4,rdPtr);
    axi_m.getData(rdPtr, dataOut, rdRespOut);
    DataUnpack32(data,dataOut);
  endtask // pulp_read64

  int j = 0;

  // preload TCDM banks
  generate for (genvar iCluster = 0; iCluster < 4; iCluster++) begin
    for (genvar iTcdmBank = 0; iTcdmBank < 16; iTcdmBank++) begin
      initial begin
        $readmemh($sformatf("../../../../tb/current/slm_files/tcdm_bank%01d.slm", iTcdmBank),
          DUT.pulp_soc_i.CLUSTER[iCluster].cluster_i.pulp_cluster_i.tcdm_banks_i.banks_gen[iTcdmBank].SyncSpRamBeNx32_i.Mem_DP);
      end
    end
  end endgenerate

  initial begin : main
    bit8 dataIn[], dataOut[], wrRespOut[], wrRespExp[], rdRespOut[], rdRespExp[];
    int unsigned rdPtr, address, wrRespPtr;
    AXI4Lite_m_env axi_m;

    int unsigned status;

    // Create AXI master
    axi_m    = new("AXI master", testbench.axi_m_if_0, 8);
    // Start master vip
    axi_m.startEnv();
    axi_m.setRndDelay(0, 0, 0, 0);
    axi_m.setTimeOut(10000, 100000);
    axi_m.respReportMode(1);

    ARESETn = 1'b1; // interfaces, clking
    tb_wait(1);
    ARESETn = 1'b0;
    tb_wait(50);
    ARESETn = 1'b1; // release reset for interfaces, clking
    tb_wait(100);

    // // setup clking @ 50 MHz
    // // write configuration: 50 MHz
    // pulp_write32(axi_m, 32'h6E01_0000 + 12'h200, 32'h0400_0A01);
    // pulp_write32(axi_m, 32'h6E01_0000 + 12'h208, 32'h0004_0014); // 50 MHz
    //
    // // read status
    // pulp_read32(axi_m, 32'h6E01_0000 + 4'h4, status);
    //
    // // confirm config
    // pulp_write32(axi_m, 32'h6E01_0000 + 12'h25c,4'h7);
    // pulp_write32(axi_m, 32'h6E01_0000 + 12'h25c,4'h2);

    // wait for lock of clocking_wizard
    wait (DUT.clk_rst_gen_i.clk_manager_i.locked == 1'b1);

    tb_wait(16);

    // release PULP resets
    pulp_write32(axi_m, 32'h6E000000 + 4'h8, 32'hC0000000); // release GPIO reset for PULP
    tb_wait(100);

    // preload L2 memory
    $readmemh("../../../../tb/current/slm_files/l2_ram_cut0_lo.slm", DUT.pulp_soc_i.l2_mem_i.l2_generic_i.cut_lo.MEM);
    $readmemh("../../../../tb/current/slm_files/l2_ram_cut0_hi.slm", DUT.pulp_soc_i.l2_mem_i.l2_generic_i.cut_hi.MEM);

    // setup a RAB slice for the mailbox
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h20, 32'h6512_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h28, 32'h6512_2000);
    pulp_write64(axi_m, 32'h6E03_0000 + 8'h30, 32'h1A12_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h38, 32'h7);

    // mailbox config, interrupt enable
    pulp_write32(axi_m, 32'h6512_0000 + 8'h24, 4'h6);

    // setup a RAB slice for the L2
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h40, 32'h6700_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h48, 32'h6701_0000);
    pulp_write64(axi_m, 32'h6E03_0000 + 8'h50, 32'h1C00_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h58, 32'h7);

    // setup a RAB slice for the L1
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h60, 32'h6000_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h68, 32'h6100_0000);
    pulp_write64(axi_m, 32'h6E03_0000 + 8'h70, 32'h1000_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h78, 32'h7);

    // setup a RAB slice for the L3 -> Used by the testbench to setup the shared data structure
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h80, 32'h6600_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h88, 32'h6700_0000);
    pulp_write64(axi_m, 32'h6E03_0000 + 8'h90, 32'h8000_0000);
    pulp_write32(axi_m, 32'h6E03_0000 + 8'h98, 32'h7);

    // setup a RAB slice for the L3
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h00, 32'h8000_0000);
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h08, 32'h800F_FFFF);
    pulp_write64(axi_m, 32'h6E03_00A0 + 8'h10, 36'h9_F800_0000);
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h18, 32'h7);

    // Build up graph structure in BRAMs.
    `include "graph_mem.sv"

    // Set up a RAB slice for the PMD - with STATIC_PMD_SLICES, the PGD is not used.
    // Use PMD Section 2 (Bits 31 - 30 of 0x8000_0000)
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h20, 32'h2000_2000);
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h28, 32'h2000_2FFF);
    pulp_write64(axi_m, 32'h6E03_00A0 + 8'h30, 36'h9_F80F_0000);
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h38, 32'h3);

    // Write PMD Entry 0 (Bits 29 - 21 of 0x8000_0000)
    pulp_write64(axi_m, 32'h660F_0000, 36'h9_F80F_1003);
    pulp_read64(axi_m, 32'h660F_0000, status);
    $display("PGD Entry 2 Readback: %h\n", status);

    // Write PTE entries.
    for (int iPage = 0; iPage < 252; iPage++) begin
        pulp_write64(axi_m, 32'h660F_1000 + 4'h8*iPage, 36'h9_F800_0043 + 16'h1000*iPage);
    end

    // Disable RAB slice for the L3 (when using mem_sharing = 3) - it was only used to initialize the simulation.
    pulp_write32(axi_m, 32'h6E03_00A0 + 8'h18, 32'h0);

    // start program execution
    pulp_write32(axi_m, 32'h6E00_0000 + 4'h8, 32'hC800_0001); // enable the RAB AXI Logger

    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'h01); // status
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'h03); // mem_sharing
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'd01); // n_iterations
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'd10); // n_cycles_per_vertex
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'h8000_0000); // &vertices
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'd46); // n_vertices
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'd03); // n_successors_max
    pulp_write32(axi_m, 32'h6512_0000 + 4'h0, 32'h01); // status

    // Wait for EOC.
    wait (DUT.intr_eoc[0] == 1'b1);
    $display("EOC received, finishing simulation in an instant.\n");
  end // main

  initial begin : clk_gen
    ACLK = 1'b1;
    #(clk_period/2-1);
    while(1) begin
      ACLK = 1'b0;
      #(clk_period/2);
      ACLK = 1'b1;
      #(clk_period/2);
    end
  end

endmodule