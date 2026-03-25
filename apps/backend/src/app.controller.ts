import { Controller, Get } from "@nestjs/common";

@Controller()
export class AppController {
  @Get()
  getRoot() {
    return {
      name: "Bir Yuva Bir Dost API",
      status: "ok",
      message: "Backend hazir. Prisma ve PostgreSQL ile gelistirmeye baslayabilirsiniz.",
    };
  }

  @Get("health")
  getHealth() {
    return {
      status: "ok",
      timestamp: new Date().toISOString(),
    };
  }
}
