import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("SimpleAccountModule", (m) => {
  const entryPoint = "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"; // Replace with your actual EntryPoint address
  const simpleAccount = m.contract("SimpleAccount", [entryPoint]);

  return { simpleAccount };
});
