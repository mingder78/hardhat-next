import { randomBytes } from 'crypto';

const salt = '0x' + randomBytes(32).toString('hex'); // 32-byte hex string
console.log(salt); // e.g., 0x83e92a6f...