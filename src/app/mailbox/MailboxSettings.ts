import { Title } from "@angular/platform-browser";

export interface MailboxSettings{
    title: string;
    userName: string;
    emailAddress: string;
    signature: string;
    imapUrl: string;
    imapUserName: string;
    imapPort: number;
}